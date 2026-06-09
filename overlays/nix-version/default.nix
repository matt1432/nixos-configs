self: {nix ? null}: final: prev: let
  inherit (builtins) mapAttrs;

  inherit (self.inputs) nix-eval-jobs nix-output-monitor;

  inherit (final.lib) pipe remove;
  inherit (final.stdenv.hostPlatform) system;

  isX86 = system == "x86_64-linux";

  nullCheck = n: v:
    if nix == null
    then prev.${n}
    else v;
in
  mapAttrs nullCheck {
    inherit nix;

    # Can't use `overrideAll` because of the package's complexity upstream
    nix-output-monitor = nix-output-monitor.packages.${system}.default.overrideAttrs (o: {
      # NOTE: https://github.com/maralorn/nix-output-monitor/issues/273
      outputs =
        if isX86
        then o.outputs
        else remove "test" o.outputs;
      postPatch = ''
        ${o.postPatch or ""}

        sed -i 's/.*" nom hasn‘t detected any input. Have you redirected nix-build stderr into nom? (See -h and the README for details.)".*//' ./lib/NOM/Print.hs
      '';
    });

    nix-serve = pipe final.nix-serve-ng [
      (final.haskell.lib.compose.overrideSrc (import ./nix-serve-ng-src.nix final))
    ];

    nix-eval-jobs =
      if isX86
      then nix-eval-jobs.packages.${system}.default.override {pkgs = final;} // {inherit nix;}
      else prev.nix-eval-jobs;
  }
