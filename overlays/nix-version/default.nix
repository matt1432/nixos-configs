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
      # FIXME: remove this once nix-serve-ng 1.1.0 reaches nixpkgs https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/haskell-modules/configuration-nix.nix
      (final.haskell.lib.compose.overrideSrc {
        version = "1.1.0";
        src = final.fetchFromGitHub {
          repo = "nix-serve-ng";
          owner = "aristanetworks";
          rev = "3b9c80f78501813b1a29c5b33a3ccc50a7506f0e";
          hash = "sha256-dbjGP/uD2WeGYf6A5CmLb6z5owleoYXybFbkTcWSvxA=";
        };
      })
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
