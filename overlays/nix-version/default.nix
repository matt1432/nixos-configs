self: {nix ? null}: final: prev: let
  inherit (builtins) mapAttrs;
  inherit (self.inputs) nix-eval-jobs nix-fast-build;

  nullCheck = n: v:
    if nix == null
    then prev.${n}
    else v;
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

    nix-fast-build = nix-fast-build.packages.${final.system}.nix-fast-build.override {
      inherit (final) nix-output-monitor;

      nix-eval-jobs = nix-eval-jobs.packages.${final.system}.default.override {
        inherit nix;
      };
    };
  }
