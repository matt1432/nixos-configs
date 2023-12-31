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


doAll() {
    updateFFZ
    updateFirefoxAddons
}


[[ "$1" == "-a" || "$1" == "--all" ]] && doAll
[[ "$1" == "-f" || "$1" == "--firefox" ]] && updateFirefoxAddons
[[ "$1" == "-ffz" || "$1" == "--frankerfacez" ]] && updateFFZ

alejandra /home/matt/.nix
