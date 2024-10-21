#!/usr/bin/env bash

file="$FLAKE/legacyPackages/lovelace-components/custom-sidebar/default.nix"
old_hash="$(sed -n 's/.*hash = "\(.*\)";/\1/p' "$file")"

sed -i "s/hash = .*/hash = \"\";/" "$file"
npm_hash="$(nix build "$FLAKE#legacyPackages.x86_64-linux.lovelace-components.custom-sidebar" |& sed -n 's/.*got: *//p')"

if [[ "$npm_hash" != "$old_hash" ]]; then
    sed -i "s/hash = .*/hash = \"$npm_hash\";/" "$FLAKE/legacyPackages/lovelace-components/custom-sidebar/default.nix"
else
    sed -i "s/hash = .*/hash = \"$old_hash\";/" "$FLAKE/legacyPackages/lovelace-components/custom-sidebar/default.nix"
fi
