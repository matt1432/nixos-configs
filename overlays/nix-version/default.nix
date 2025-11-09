self: {nix ? null}: final: prev: let
  inherit (builtins) mapAttrs replaceStrings;
  inherit (final.lib) generateSplicesForMkScope versions;

  inherit (self.inputs) nix-eval-jobs nix-fast-build nix-output-monitor;

  inherit (final.stdenv.hostPlatform) system;

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

    # Can't use `overrideAll` because of the package's complexity upstream
    nix-output-monitor = nix-output-monitor.packages.${system}.default.overrideAttrs (o: {
      postPatch = ''
        ${o.postPatch or ""}

        sed -i 's/.*" nom hasn‘t detected any input. Have you redirected nix-build stderr into nom? (See -h and the README for details.)".*//' ./lib/NOM/Print.hs
      '';
    });

    nix-eval-jobs =
      (overrideAll nix-eval-jobs.packages.${system}.default {
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

    nix-fast-build = overrideAll nix-fast-build.packages.${system}.nix-fast-build {};
  }
