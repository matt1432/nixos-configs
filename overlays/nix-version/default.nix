self: {nix ? null}: final: prev: let
  inherit (builtins) mapAttrs;

  inherit (self.inputs) nix-output-monitor;

  inherit (final.lib) pipe;
  inherit (final.stdenv.hostPlatform) system;

  nullCheck = n: v:
    if nix == null
    then prev.${n}
    else v;
in
  mapAttrs nullCheck {
    inherit nix;

    # Can't use `overrideAll` because of the package's complexity upstream
    nix-output-monitor = nix-output-monitor.packages.${system}.default.overrideAttrs (o: {
      postPatch = ''
        ${o.postPatch or ""}

        sed -i 's/.*" nom hasn‘t detected any input. Have you redirected nix-build stderr into nom? (See -h and the README for details.)".*//' ./lib/NOM/Print.hs
      '';
    });

    nix-serve = pipe (final.nix-serve-ng.override {inherit nix;}) [
      (final.haskell.lib.compose.enableCabalFlag "lix")
      (final.haskell.lib.compose.overrideSrc (import ./nix-serve-ng-src.nix final))
    ];

    inherit
      (prev.lixPackageSets.stable)
      nix-eval-jobs
      ;

    nix-fast-build = prev.nix-fast-build.override {
      inherit
        (prev.lixPackageSets.stable)
        nix-eval-jobs
        ;
    };
  }
