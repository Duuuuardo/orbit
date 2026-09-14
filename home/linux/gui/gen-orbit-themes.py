import json
import re
import sys


def parse_scheme_colours(path):
    colours = {}
    for line in open(path):
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        key, _, value = line.partition(" ")
        key = key.strip()
        value = value.strip()
        if key and re.fullmatch(r"[0-9a-fA-F]{6,8}", value):
            colours[key] = value
    return colours


class Colour:
    def __init__(self, hex):
        hex = hex.ljust(8, "f")
        self.raw = hex
        self.rgb_vals = tuple(int(hex[i : i + 2], 16) for i in range(0, 7, 2))

    @property
    def hex(self):
        return self.raw[:-2]

    @property
    def hexalpha(self):
        return self.raw

    @property
    def rgb(self):
        return f"rgb({','.join(map(str, self.rgb_vals[:-1]))})"

    @property
    def rgbalpha(self):
        return f"rgba({','.join(map(str, self.rgb_vals))})"

    def to_hsl(self):
        r, g, b = (v / 255 for v in self.rgb_vals[:3])
        cmax, cmin = max(r, g, b), min(r, g, b)
        delta = cmax - cmin
        lightness = (cmax + cmin) / 2
        saturation = 0 if delta == 0 else delta / (1 - abs(2 * lightness - 1))
        if delta == 0:
            hue = 0
        elif cmax == r:
            hue = 60 * (((g - b) / delta) % 6)
        elif cmax == g:
            hue = 60 * (((b - r) / delta) + 2)
        else:
            hue = 60 * (((r - g) / delta) + 4)
        return (round(hue), round(saturation * 100), round(lightness * 100))

    def field(self, form):
        if form == "hex":
            return self.hex
        if form == "hexalpha":
            return self.hexalpha
        if form == "rgb":
            return self.rgb
        if form == "rgbalpha":
            return self.rgbalpha
        if form == "red":
            return str(self.rgb_vals[0])
        if form == "green":
            return str(self.rgb_vals[1])
        if form == "blue":
            return str(self.rgb_vals[2])
        if form == "hsl":
            return f"hsl({','.join(map(str, self.to_hsl()))}%)"
        if form == "hue":
            return str(self.to_hsl()[0])
        if form == "saturation":
            return str(self.to_hsl()[1])
        if form == "lightness":
            return str(self.to_hsl()[2])
        return None


def fill_dynamic(template, colours, mode):
    dot_field = r"\{\{((?:(?!\{\{|\}\}).)*)\}\}"
    template = re.sub(r"\{\{\s*mode\s*\}\}", mode, template)

    def fill(match):
        data = match.group(1).strip().split(".")
        if len(data) != 2:
            return match.group()
        name, form = data
        colour = colours.get(name)
        if colour is None:
            return match.group()
        val = colour.field(form)
        return match.group() if val is None else val

    return re.sub(dot_field, fill, template)


def fill_hashed(template, colours):
    for name, value in colours.items():
        template = template.replace(f"{{{{ ${name} }}}}", f"#{value}")
    return template


def main():
    scheme_path, named_path, template_path, kind = sys.argv[1:5]
    scheme = json.load(open(scheme_path))
    colours = dict(scheme["colours"])
    for key, value in parse_scheme_colours(named_path).items():
        colours.setdefault(key, value)
    mode = scheme.get("mode", "dark")
    template = open(template_path).read()

    if kind == "zed":
        sys.stdout.write(fill_dynamic(template, {k: Colour(v) for k, v in colours.items()}, mode))
    else:
        sys.stdout.write(fill_hashed(template, colours))


if __name__ == "__main__":
    main()