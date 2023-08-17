#!/usr/bin/env python

"""
The original script:
https://github.com/dharmx/vile/blob/7d486c128c7e553912673755f97b118aaab0193d/src/shell/playerctl.py#L2
"""

import argparse
import utils
from material_color_utilities_python import *

parser = argparse.ArgumentParser(
                    prog='coloryou',
                    description='Extract Material You colors from an image',
                    epilog='coucou')

parser.add_argument("image_path", help="A full path to your image", type=str)
args = parser.parse_args()

def get_material_you_colors(image_path: str) -> dict:
    """Get the material you pallete colors from an image and save them to a
    JSON file if it isn't already. Then return the path to that JSON file.

    Arguments:
        image_path: The location of the image.

    Returns:
        A dict of image accent color, button accent color and button text color eg: {'image_accent': '#292929', 'button_accent': '#BEBFC1', 'button_text': '#292929'}
    """
    
    """if image_path == default_cover:
        return {'image_accent': '#292929', 'button_accent': '#BEBFC1', 'button_text': '#292929'}"""

    img = Image.open(image_path)
    basewidth = 64
    wpercent = (basewidth/float(img.size[0]))
    hsize = int((float(img.size[1])*float(wpercent)))
    img = img.resize((basewidth,hsize),Image.Resampling.LANCZOS)

    theme = themeFromImage(img)
    themePalette = theme.get("palettes")
    themePalettePrimary = themePalette.get("primary")
    parsed_colors = {"image_accent": hexFromArgb(themePalettePrimary.tone(40)), "button_accent": hexFromArgb(themePalettePrimary.tone(90)), "button_text": hexFromArgb(themePalettePrimary.tone(10))}

    # parsed_colors = {"bright": colors[3], "dark": colors[9]}
    return parsed_colors

print(get_material_you_colors(args.image_path))
