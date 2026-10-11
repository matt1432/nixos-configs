self: {nix ? null}: final: prev: let
  inherit (builtins) mapAttrs;

  inherit (self.inputs) nix-eval-jobs nix-output-monitor nix-fast-build;

  inherit (final.lib) pipe;
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
      postPatch = ''
        ${o.postPatch or ""}

        sed -i 's/.*" nom hasn‘t detected any input. Have you redirected nix-build stderr into nom? (See -h and the README for details.)".*//' ./lib/NOM/Print.hs
      '';

      # NOTE: https://github.com/maralorn/nix-output-monitor/pull/321
      patches =
        o.patches or []
        ++ [
          (prev.fetchpatch2 {
            url = "https://patch-diff.githubusercontent.com/raw/maralorn/nix-output-monitor/pull/321.patch";
            relative = "nix-output-monitor";
            hash = "sha256-uleti4hBzGN/uQS7CxUi4FaVs+fy+Q/rmqDPNPXBNiM=";
          })
        ];
    });

    nix-fast-build = nix-fast-build.packages.${system}.default.override {
      inherit (final) nix-output-monitor nix-eval-jobs;
    };

    nix-serve = pipe final.nix-serve-ng [
      (final.haskell.lib.compose.overrideSrc (import ./nix-serve-ng-src.nix final))
    ];

    nix-eval-jobs =
      if isX86
      then nix-eval-jobs.packages.${system}.default // {inherit nix;}
      else prev.nix-eval-jobs;
  }
