#!/usr/bin/env bash

parseNurl() {
    REV=$(nurl -j "$1" | jq '.["args"].["rev"]')
    HASH=$(nurl -j "$1" | jq '.["args"].["hash"]')

    sed -i "s,rev = .*,rev = $REV;," "$2"
    sed -i "s,hash = .*,hash = $HASH;," "$2"
}

parseFetchurl() {
    URL="$1"
    FILE="$2"
    HASH="$(nix store prefetch-file --refresh --json \
            --hash-type sha256 "$URL" --name "escaped" | jq -r .hash)"

    sed -i "s,url = .*,url = \"$URL\";," "$FILE"
    sed -i "s,hash = .*,hash = \"$HASH\";," "$FILE"

    # For Firefox addons
    sed -i "s,sha256 = .*,sha256 = \"$HASH\";," "$FILE"
}


updateOverlays() {
    FILE="/home/matt/.nix/common/overlays"
    parseNurl "https://github.com/dasJ/spotifywm" "$FILE/spotifywm/spotifywm.nix"
}

updateDracula() {
    FILE="/home/matt/.nix/common/overlays/dracula-theme"
    parseNurl "https://github.com/matt1432/bat"       "$FILE/bat.nix"
    parseNurl "https://github.com/dracula/gtk"        "$FILE/default.nix"
    parseNurl "https://github.com/dracula/plymouth"   "$FILE/plymouth.nix"
    parseNurl "https://github.com/dracula/git"        "$FILE/git.nix"
    parseNurl "https://github.com/dracula/xresources" "$FILE/xresources.nix"
    parseFetchurl "https://github.com/aynp/dracula-wallpapers/blob/main/Art/4k/Waves%201.png?raw=true" "$FILE/wallpaper.nix"
}

updateCustomPkgs() {
    FILE="/home/matt/.nix/common/pkgs"
    parseNurl "https://github.com/tio/input-emulator" "$FILE/input-emulator/default.nix"
    parseNurl "https://gitlab.com/mishakmak/pam-fprint-grosshack" "$FILE/pam-fprint-grosshack/default.nix"
    parseNurl "https://gitlab.com/phoneybadger/pokemon-colorscripts" "$FILE/pokemon-colorscripts/default.nix"
}

updateFFZ() {
    FILE="/home/matt/.nix/home/firefox/addons/default.nix"
    URL="https://cdn.frankerfacez.com/script/frankerfacez-4.0-an+fx.xpi"

    parseFetchurl "$URL" "$FILE"
}

updateFirefoxAddons() {
    echo "Updating firefox addons using mozilla-addons-to-nix"

    (cd /home/matt/.nix/home/firefox/addons || return;

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

updateGSR() {
    (
        cd /tmp || return

        git clone https://repo.dec05eba.com/gpu-screen-recorder
        cd gpu-screen-recorder || return

        REV=$(printf "r%s.%s\n" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)")
        URL=https://dec05eba.com/snapshot/gpu-screen-recorder.git."$REV".tar.gz
        FILE="/home/matt/.nix/devices/binto/modules/gpu-replay.nix"

        parseFetchurl "$URL" "$FILE"
    )
}


doAll() {
    updateFFZ
    updateCustomPkgs
    updateOverlays
    updateDracula
    updateFirefoxAddons
    updateGSR
}


[[ "$1" == "-a" || "$1" == "--all" ]] && doAll
[[ "$1" == "-d" || "$1" == "--dracula" ]] && updateDracula
[[ "$1" == "-c" || "$1" == "--custom" ]] && updateCustomPkgs
[[ "$1" == "-o" || "$1" == "--overlays" ]] && updateOverlays
[[ "$1" == "-f" || "$1" == "--firefox" ]] && updateFirefoxAddons
[[ "$1" == "-ffz" || "$1" == "--frankerfacez" ]] && updateFFZ
[[ "$1" == "-gsr" || "$1" == "--gpu-screen-recorder" ]] && updateGSR

alejandra /home/matt/.nix
