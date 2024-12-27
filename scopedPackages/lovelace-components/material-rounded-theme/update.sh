#!/usr/bin/env bash

file="$FLAKE/scopedPackages/lovelace-components/material-rounded-theme/default.nix"
old_hash="$(sed -n 's/.*hash = "\(.*\)";/\1/p' "$file")"

sed -i "s/hash = .*/hash = \"\";/" "$file"
npm_hash="$(nix build "$FLAKE#scopedPackages.x86_64-linux.lovelace-components.material-rounded-theme" |& sed -n 's/.*got: *//p')"

if [[ "$npm_hash" != "$old_hash" ]]; then
    sed -i "s#hash = .*#hash = \"$npm_hash\";#" "$file"
else
    sed -i "s#hash = .*#hash = \"$old_hash\";#" "$file"
fi
