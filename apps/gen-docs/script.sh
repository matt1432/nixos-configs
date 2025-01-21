getMetaFunc=$(cat << EOF
(x: {
    attrs = builtins.mapAttrs (_: v: {
        desc = builtins.replaceStrings ["\n"] [" "] (v.meta.description or "");
        homepage = v.meta.homepage or "";
        roleDesc = builtins.replaceStrings ["\n"] [" "] (v.config.meta.roleDescription or "");
        hwDesc = builtins.replaceStrings ["\n"] [" "] (v.config.meta.hardwareDescription or "");
    }) (builtins.removeAttrs (x.\${builtins.currentSystem} or x) ["default"]);
})
EOF
)


substitute() {
    echo '' | pandoc --metadata-file <(
        nix eval \
            --impure \
            --json \
            "$FLAKE"#"$1" \
            --apply "$getMetaFunc" |
            jq -r
    ) -t markdown --template "$FLAKE/apps/gen-docs/templates/$2.md" -o "$FLAKE/$2/README.md"
}

# TODO: add homeManagerModules, lib, modules, nixFastChecks, overlays, scopedPackages
substitute "appsPackages" "apps"
substitute "nixosConfigurations" "configurations"
substitute "devShells" "devShells"
substitute "packages" "packages"
