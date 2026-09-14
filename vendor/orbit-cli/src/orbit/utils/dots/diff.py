from dataclasses import dataclass, field
from pathlib import Path

from orbit.utils.dots.manifest import ManifestEntry
from orbit.utils.dots.source import DotsSource, SourceError
from orbit.utils.io import warn

class _Continue(Exception):
    """Signals the deployed-files loop to skip to the next entry."""

def _read_local(path: Path) -> bytes | None:
    """Read a local file, returning None if it can't be read (perms, is a dir, etc.)."""

    try:
        return path.read_bytes()
    except OSError:
        return None

@dataclass(frozen=True)
class Changeset:
    place: list[tuple[str, Path]] = field(default_factory=list)                                    
    conflicts: list[tuple[str, Path]] = field(default_factory=list)                                  
    deletes: list[Path] = field(default_factory=list)                                                 
    stale: list[Path] = field(default_factory=list)                                            
    deleted_changed: list[tuple[str, Path]] = field(default_factory=list)                                             
    untracked: list[Path] = field(default_factory=list)                                             
    remap: list[tuple[str, Path]] = field(default_factory=list)                                                     

    def is_empty(self) -> bool:
        return not (self.place or self.conflicts or self.deletes or self.stale or self.deleted_changed)

    @staticmethod
    def compute(
        source: DotsSource,
        applied_rev: str,
        tip: str,
        entries: list[ManifestEntry],
        deployed: dict[str, str],
    ) -> "Changeset":
        """Collect all file changes needed into a Changeset."""

        has_base = source.has_rev(applied_rev)
        if not has_base:
            warn(
                "the previously applied revision is missing from the dots clone; files that differ "
                "from the latest version will be written as .new instead of updated in place."
            )

        changed = set(source.changed_files(applied_rev, tip)) if has_base else set()
        place: list[tuple[str, Path]] = []
        conflicts: list[tuple[str, Path]] = []
        deletes: list[Path] = []
        stale: list[Path] = []
        deleted_changed: list[tuple[str, Path]] = []
        untracked: list[Path] = []
        remap: list[tuple[str, Path]] = []

                                                                                         
        to_deploy: dict[Path, str] = {}
        for entry in entries:
            src_root = str(entry.expanded_src())
            repo_files = source.files_at(tip, src_root)
            for dest in entry.expanded_dests():
                for repo_file in repo_files:
                    to_deploy[dest / Path(repo_file).relative_to(src_root)] = repo_file
        files_to_deploy = set(to_deploy)

                                
        for dest, src in deployed.items():
            dest_path = Path(dest)

            def try_read(rev: str, path: str) -> bytes:
                try:
                    return source.blob_at(rev, path)
                except SourceError:
                                                       
                    stale.append(dest_path)
                    raise _Continue

            try:
                if dest_path not in files_to_deploy:                                  
                    if not dest_path.exists():
                                                                
                        untracked.append(dest_path)
                        continue

                    local = _read_local(dest_path)
                    if local is not None and has_base and try_read(applied_rev, src) == local:
                        deletes.append(dest_path)
                    else:
                                                                                          
                        stale.append(dest_path)
                else:                                                                             
                    new_src = to_deploy[dest_path]
                    if not dest_path.exists():
                                                             
                        if has_base and new_src == src and new_src not in changed:
                            continue                                                           
                                                                                                  
                        deleted_changed.append((new_src, dest_path))
                        continue

                    if has_base and new_src == src and new_src not in changed:
                        continue                      

                    dest_content = _read_local(dest_path)
                    if dest_content is None:
                                                                                                        
                        conflicts.append((new_src, dest_path))
                        continue

                    if try_read(tip, new_src) == dest_content:
                                                                                          
                        if new_src != src:
                            remap.append((new_src, dest_path))
                        continue

                                                                                     
                    if has_base and try_read(applied_rev, src) == dest_content:
                        place.append((new_src, dest_path))
                    else:
                        conflicts.append((new_src, dest_path))
            except _Continue:
                continue

                             
        for dest in files_to_deploy - set(Path(d) for d in deployed):
            src = to_deploy[dest]
            try:
                new_content = source.blob_at(tip, src)
            except SourceError:
                                                                                           
                warn(f"could not read from source, skipping: {src}")
                continue
            if not dest.exists() or new_content == _read_local(dest):
                                                                  
                place.append((src, dest))
            else:
                                                                             
                conflicts.append((src, dest))

        return Changeset(
            place=place,
            conflicts=conflicts,
            deletes=deletes,
            stale=stale,
            deleted_changed=deleted_changed,
            untracked=untracked,
            remap=remap,
        )
