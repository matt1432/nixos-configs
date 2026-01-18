substituteDerivs() {
    echo '' | pandoc --metadata-file <(
        nix eval \
            --impure \
            --json \
            "$FLAKE"#"$1" \
            --apply "import \"$FLAKE/apps/gen-docs/$3.nix\"" |
            jq -r
    ) -t markdown --template "$FLAKE/apps/gen-docs/templates/$2.md" -o "$FLAKE/$2/README.md"
}

substituteAttrs() {
    echo '' | pandoc --metadata-file <(
        nix eval \
            --impure \
            --json \
            --expr "\"$FLAKE\"" \
            --apply "(import \"$FLAKE/apps/gen-docs/getAttrsMeta.nix\") \"$1\"" |
            jq -r
    ) -t markdown --template "$FLAKE/apps/gen-docs/templates/$1.md" -o "$FLAKE/$1/README.md"
}

substituteScopes() {
    echo '' | pandoc --metadata-file <(
        nix eval \
            --impure \
            --json \
            --expr "\"$FLAKE\"" \
            --apply "(import \"$FLAKE/apps/gen-docs/getScopesMeta.nix\") \"$1\"" |
            jq -r
    ) -t markdown --template "$FLAKE/apps/gen-docs/templates/$1.md" -o "$FLAKE/$1/README.md"
}

substituteDerivs "appsPackages" "apps" "getPackageMeta"
substituteDerivs "configurations" "configurations" "getConfigMeta"
substituteDerivs "devShells" "devShells" "getPackageMeta"
substituteDerivs "packages" "packages" "getPackageMeta"

substituteAttrs "modules"
substituteAttrs "homeManagerModules"
substituteAttrs "overlays"

substituteScopes "scopedPackages"
