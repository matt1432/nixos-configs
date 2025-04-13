self: {nix ? null}: final: prev: let
  inherit (builtins) functionArgs mapAttrs replaceStrings;
  inherit (final.lib) generateSplicesForMkScope head splitString versions;
  inherit (self.inputs) nix-eval-jobs nix-fast-build;

  nullCheck = n: v:
    if nix == null
    then prev.${n}
    else v;

  # This is for packages from flakes that don't offer overlays
  overrideAll = pkg: extraArgs: let
    pkgFile = head (splitString [":"] pkg.meta.position);
    args = functionArgs (import pkgFile);
  in
    pkg.override (mapAttrs (n: v: final.${n} or v) (args // extraArgs));
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
      (overrideAll nix-eval-jobs.packages.${final.system}.default {
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

    nix-fast-build = overrideAll nix-fast-build.packages.${final.system}.nix-fast-build {};
  }
