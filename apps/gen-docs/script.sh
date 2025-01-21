substitute() {
    echo '' | pandoc --metadata-file <(
        nix eval \
            --impure \
            --json \
            "$FLAKE"#"$1" \
            --apply "import \"$FLAKE/apps/gen-docs/$3.nix\"" |
            jq -r
    ) -t markdown --template "$FLAKE/apps/gen-docs/templates/$2.md" -o "$FLAKE/$2/README.md"
}

substituteModule() {
    echo '' | pandoc --metadata-file <(
        nix eval \
            --impure \
            --json \
            --expr "\"$FLAKE\"" \
            --apply "(import \"$FLAKE/apps/gen-docs/getModuleMeta.nix\") \"$1\"" |
            jq -r
    ) -t markdown --template "$FLAKE/apps/gen-docs/templates/$1.md" -o "$FLAKE/$1/README.md"
}

# TODO: add homeManagerModules, lib, modules, nixFastChecks, overlays, scopedPackages
substitute "appsPackages" "apps" "getPackageMeta"
substitute "nixosConfigurations" "configurations" "getConfigMeta"
substitute "devShells" "devShells" "getPackageMeta"
substitute "packages" "packages" "getPackageMeta"
substituteModule "modules"
