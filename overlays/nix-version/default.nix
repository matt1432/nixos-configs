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

    nix-fast-build = nix-fast-build.packages.${final.system}.nix-fast-build.override {
      nix-eval-jobs =
        nix-eval-jobs.packages.${final.system}.default.override {
          inherit nix;
        }
        // {
          inherit nix;
        };
    };
  }
