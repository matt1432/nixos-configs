#!/usr/bin/env python

"""
The original script:
https://github.com/dharmx/vile/blob/7d486c128c7e553912673755f97b118aaab0193d/src/shell/playerctl.py#L2
"""

import argparse
import json
from material_color_utilities_python import themeFromImage, hexFromArgb, Image

def range_type(value_string):
    value = int(value_string)
    if value not in range(0, 101):
        raise argparse.ArgumentTypeError("%s is out of range, choose in [0-100]" % value)
    return value

parser = argparse.ArgumentParser(
                    prog='coloryou',
                    description='This program extract Material You colors from an image. It returns them as a JSON object for scripting.')

parser.add_argument("image_path", help="A full path to your image", type=str)
parser.add_argument('-i', '--image', dest='image', default=40, type=range_type, metavar='i', choices=range(0,101), help="Value should be within [0, 100] (default: %(default)s). Set the tone for the main image accent.")

parser.add_argument('-b', '--button', dest='button', default=90, type=range_type, metavar='i', choices=range(0,101), help="Value should be within [0, 100] (default: %(default)s). Set the tone for the button accent.")

parser.add_argument('-t', '--text', dest='text', default=10, type=range_type, metavar='i', choices=range(0,101), help="Value should be within [0, 100] (default: %(default)s). Set the tone for the button text accent.")

parser.add_argument('-o', '--hover', dest='hover', default=80, type=range_type, metavar='i', choices=range(0,101), help="Value should be within [0, 100] (default: %(default)s). Set the tone for the hovering effect accent.")
args = parser.parse_args()


img = Image.open(args.image_path)
basewidth = 64
wpercent = (basewidth/float(img.size[0]))
hsize = int((float(img.size[1])*float(wpercent)))
img = img.resize((basewidth,hsize),Image.Resampling.LANCZOS)

theme = themeFromImage(img).get("palettes").get("primary")
parsed_colors = {"imageAccent":  hexFromArgb(theme.tone(args.image)),
                 "buttonAccent": hexFromArgb(theme.tone(args.button)),
                 "buttonText":   hexFromArgb(theme.tone(args.text)),
                 "hoverAccent":  hexFromArgb(theme.tone(args.hover))}

print(json.dumps(parsed_colors))
