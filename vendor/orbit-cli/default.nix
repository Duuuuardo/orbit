{
  rev,
  lib,
  python3,
  installShellFiles,
  swappy,
  libnotify,
  slurp,
  wl-clipboard,
  cliphist,
  xdg-utils,
  dart-sass,
  grim,
  fuzzel,
  gpu-screen-recorder,
  dconf,
  killall,
  orbit-shell ? null,
  withShell ? false,
  discordBin ? "discord",
  qtctStyle ? "Darkly",
}:
python3.pkgs.buildPythonApplication {
  pname = "orbit-cli";
  version = "${rev}";
  src = ./.;
  pyproject = true;

  build-system = with python3.pkgs; [
    hatch-vcs
    hatchling
  ];

  dependencies = with python3.pkgs; [
    materialyoucolor
    pillow
  ];

  pythonImportsCheck = ["orbit"];

  nativeBuildInputs = [installShellFiles];
  propagatedBuildInputs =
    [
      swappy
      libnotify
      slurp
      wl-clipboard
      cliphist
      xdg-utils
      dart-sass
      grim
      fuzzel
      gpu-screen-recorder
      dconf
      killall
    ]
    ++ lib.optional withShell orbit-shell;

  SETUPTOOLS_SCM_PRETEND_VERSION = 1;

  patchPhase = ''
    substituteInPlace src/orbit/subcommands/shell.py \
    	--replace-fail '"qs", "-c", "orbit"' '"orbit-shell"'
    substituteInPlace src/orbit/subcommands/screenshot.py \
    	--replace-fail '"qs", "-c", "orbit"' '"orbit-shell"'

    substituteInPlace src/orbit/subcommands/toggle.py \
    	--replace-fail 'discord' ${discordBin} \
      --replace-fail '["todoist"]' '["todoist.desktop"]'

    substituteInPlace src/orbit/data/templates/qtengine.json \
    	--replace-fail 'Darkly' '${qtctStyle}'
  '';

  postInstall = "installShellCompletion completions/orbit.fish";

  meta = {
    description = "The main control script for the Orbit dotfiles";
    license = lib.licenses.gpl3Only;
    mainProgram = "orbit";
    platforms = lib.platforms.linux;
  };
}
