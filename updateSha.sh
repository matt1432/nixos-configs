#!/usr/bin/env bash

parseNurl() {
    REV=$(nurl -j "$1" | jq '.["args"].["rev"]')
    HASH=$(nurl -j "$1" | jq '.["args"].["hash"]')

    sed -i "s,rev = .*,rev = $REV;," "$2"
    sed -i "s,hash = .*,hash = $HASH;," "$2"
}

# TODO

# https://github.com/dracula/xresources
# https://github.com/dracula/plymouth
# https://github.com/dracula/gtk

# https://gitlab.com/mishakmak/pam-fprint-grosshack
# https://github.com/tio/input-emulator

# https://extension.7tv.gg/manifest.moz.json
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
        HASH="$(nix store prefetch-file --refresh --json \
            --hash-type sha256 $URL | jq -r .hash)"

        FILE="/home/matt/.nix/devices/binto/modules/gpu-replay.nix"
        sed -i "s,url = .*,url = \"$URL\";," "$FILE"
        sed -i "s,hash = .*,hash = \"$HASH\";," "$FILE"
    )
}

doAll() {
    updateFirefoxAddons
    updateGSR
}

[[ "$1" == "-a" || "$1" == "--all" ]] && doAll
[[ "$1" == "-f" || "$1" == "--firefox" ]] && updateFirefoxAddons
[[ "$1" == "-gsr" || "$1" == "--gpu-screen-recorder" ]] && updateGSR

alejandra /home/matt/.nix
