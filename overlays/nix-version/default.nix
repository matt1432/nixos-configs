self: {nix ? null}: final: prev: let
  inherit (builtins) mapAttrs replaceStrings;
  inherit (final.lib) generateSplicesForMkScope versions;
  inherit (self.inputs) nix-eval-jobs nix-fast-build;

  nullCheck = n: v:
    if nix == null
    then prev.${n}
    else v;

  overrideAll = self.lib.overrideAll final;
in
  mapAttrs nullCheck {
    inherit nix;

    nix-serve = prev.nix-serve-ng.override {
      inherit nix;
    };

    nix-output-monitor = prev.nix-output-monitor.overrideAttrs (o: {
      postPatch = ''
        ${o.postPatch}

        sed -i 's/.*" nom hasn‘t detected any input. Have you redirected nix-build stderr into nom? (See -h and the README for details.)".*//' ./lib/NOM/Print.hs
      '';
    });

    nix-eval-jobs =
      (overrideAll nix-eval-jobs.packages.${final.stdenv.hostPlatform.system}.default {
        srcDir = null;

        nixComponents = let
          generateSplicesForNixComponents = nixComponentsAttributeName:
            generateSplicesForMkScope [
              "nixVersions"
              nixComponentsAttributeName
            ];
        in
          final.nixDependencies.callPackage "${final.path}/pkgs/tools/package-management/nix/modular/packages.nix" {
            inherit (nix) src version;
            inherit (nix.meta) maintainers;

            otherSplices = generateSplicesForNixComponents "nixComponents_${
              replaceStrings ["."] ["_"] (versions.majorMinor nix.version)
            }";
          };
      })
      // {inherit nix;};

    nix-fast-build = overrideAll nix-fast-build.packages.${final.stdenv.hostPlatform.system}.nix-fast-build {};
  }
