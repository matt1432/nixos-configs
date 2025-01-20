packageMetaFunc=$(cat << EOF
(x: {
    attrs = builtins.mapAttrs (_: v: {
        desc = builtins.replaceStrings ["\n"] [" "] (v.meta.description or "");
        homepage = v.meta.homepage or "";
    }) (builtins.removeAttrs x.\${builtins.currentSystem} ["default"]);
})
EOF
)


substitute() {
    echo '' | pandoc --metadata-file <(
        nix eval \
            --impure \
            --json \
            "$FLAKE"#"$1" \
            --apply "$packageMetaFunc" |
            jq -r
    ) -t markdown --template "$2" -o "$3"
}

# TODO: add configurations, homeManagerModules, lib, modules, nixFastChecks, overlays, scopedPackages
substitute "appsPackages" "$FLAKE/apps/gen-docs/templates/apps.md" "$FLAKE/apps/README.md"
substitute "devShells" "$FLAKE/apps/gen-docs/templates/devShells.md" "$FLAKE/devShells/README.md"
substitute "packages" "$FLAKE/apps/gen-docs/templates/packages.md" "$FLAKE/packages/README.md"
