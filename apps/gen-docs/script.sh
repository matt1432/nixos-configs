substitute() {
    echo '' | pandoc --metadata-file <(
        nix eval \
            --impure \
            --json \
            .#"$1" \
            --apply "(x: {attrs = builtins.mapAttrs (_: v: v.meta.description or \"\") x.\${builtins.currentSystem};})" |
            jq -r
    ) -t markdown --template "$2" -o "$3"
}

substitute "devShells" "./templates/devShells.md" "$FLAKE/devShells/README.md"
