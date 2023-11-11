#!/usr/bin/env bash

parseNurl() {
  REV=$(nurl -j "$1" | jq '.["args"].["rev"]')
  HASH=$(nurl -j "$1" | jq '.["args"].["hash"]')

  sed -i "s,rev = .*,rev = $REV;," "$2"
  sed -i "s,hash = .*,hash = $HASH;," "$2"
}

updateVencord() {
  parseNurl https://github.com/Vendicated/Vencord /home/matt/.nix/common/overlays/vencord.nix
}

# TODO
#parseNurl "https://github.com/lukas-reineke/indent-blankline.nvim"

# https://github.com/dracula/xresources
# https://github.com/dracula/plymouth
# https://github.com/dracula/gtk

# https://gitlab.com/mishakmak/pam-fprint-grosshack
# https://github.com/tio/input-emulator

# https://extension.7tv.gg/manifest.moz.json
updateFirefoxAddons() {
    echo "Updating firefox addons using mozilla-addons-to-nix"

    (cd /home/matt/.nix/modules/firefox/addons || return;

     file=generated-firefox-addons.nix
     if [[ -f $file ]]; then
         printf "\nOld versions: \n"

         grep -A 1 --no-group-separator 'pname' "$file" |
         awk '{ gsub(/"/, ""); gsub(/;/, ""); print $3 }' |
         awk 'NR%2{printf $0" version ";next;}1' | paste -sd'\n' -

         printf "\nNew versions: \n"
     fi

     mozilla-addons-to-nix addons.json generated-firefox-addons.nix)
}

doAll() {
    updateFirefoxAddons
}

[[ "$1" == "-a" || "$1" == "--all" ]] && doAll
[[ "$1" == "-v" || "$1" == "--vencord" ]] && updateVencord
[[ "$1" == "-f" || "$1" == "--firefox" ]] && updateFirefoxAddons
