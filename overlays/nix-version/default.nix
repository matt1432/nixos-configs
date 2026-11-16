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
  // {
    # Not null-checked since flake outputs don't set `nix`
    nix-update =
      (prev.nix-update.override {
        # Use the Nix from PATH instead of nixpkgs'
        nix = final.emptyDirectory;
      }).overridePythonAttrs (o: {
        # `nix flake metadata` doesn't copy the flake to the store anymore
        postPatch = ''
          ${o.postPatch or ""}

          substituteInPlace nix_update/options.py \
            --replace-fail '"flake", "metadata"' '"flake", "archive"'
        '';

        # Lazy trees break position sanitization
        makeWrapperArgs =
          (o.makeWrapperArgs or [])
          ++ final.lib.optionals isX86 ["--suffix" "NIX_CONFIG" "\n" "lazy-trees = false"];
      });
  }
