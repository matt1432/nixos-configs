packageMetaFunc=$(cat << EOF
(x: {
    attrs = builtins.mapAttrs (_: v: {
        desc = v.meta.description or "";
        homepage = v.meta.homepage or "";
    }) x.\${builtins.currentSystem};
})
EOF
)


substitute() {
    echo '' | pandoc --metadata-file <(
        nix eval \
            --impure \
            --json \
            .#"$1" \
            --apply "$packageMetaFunc" |
            jq -r
    ) -t markdown --template "$2" -o "$3"
}

substitute "devShells" "$FLAKE/apps/gen-docs/templates/devShells.md" "$FLAKE/devShells/README.md"
