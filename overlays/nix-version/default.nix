{nix ? null}: (
  final: prev:
    builtins.mapAttrs
    (n: v:
      if nix == null
      then prev.${n}
      else v)
    {
      inherit nix;

      nix-serve-ng = prev.nix-serve-ng.override {
        inherit nix;
      };
    }
)
