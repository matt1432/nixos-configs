#!/usr/bin/env -S nix shell nixpkgs#jq nixpkgs#git -c bash

DIR="$FLAKE/packages/komf"

tag="$(curl -s "https://api.github.com/repos/Snd-R/komf/releases" |
    jq -r 'map(.tag_name)[]' |
    head -n 1)"

old_commit="$(nix eval --raw -f "$DIR/version.nix" rev)"

new_commit="$(nix eval --raw --impure --expr "(builtins.getFlake \"$FLAKE\").inputs.komf-src.rev")"

cat <<EOF > "$DIR/version.nix"
{
  rev = "$new_commit";
  tag = "$tag";
}
EOF

if [[ "$old_commit" != "$new_commit" ]]; then
    cd "$FLAKE" || exit 1
    eval "$(nix build .#komf.mitmCache.updateScript --no-link --print-out-paths)"
fi
