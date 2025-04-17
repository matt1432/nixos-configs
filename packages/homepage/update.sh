#!/usr/bin/env bash

nix-update --flake homepage -q --commit-message | head -n 1

file="$FLAKE/packages/homepage/default.nix"
old_hash="$(sed -n 's/.*pnpmDepsHash = "\(.*\)";/\1/p' "$file")"

sed -i "s/pnpmDepsHash = .*/pnpmDepsHash = \"\";/" "$file"
npm_hash="$(nix build "$FLAKE#homepage" |& sed -n 's/.*got: *//p')"

if [[ "$npm_hash" != "$old_hash" ]]; then
    sed -i "s#pnpmDepsHash = .*#pnpmDepsHash = \"$npm_hash\";#" "$file"
else
    sed -i "s#pnpmDepsHash = .*#pnpmDepsHash = \"$old_hash\";#" "$file"
fi
