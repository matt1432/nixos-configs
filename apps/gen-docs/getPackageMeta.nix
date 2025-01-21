x: let
  inherit (builtins) currentSystem mapAttrs removeAttrs replaceStrings;

  trimNewlines = s: replaceStrings ["\n"] [" "] s;
  packages = removeAttrs x.${currentSystem} ["default"];
in {
  attrs =
    mapAttrs (_: v: {
      desc = trimNewlines (v.meta.description or "");
      homepage = v.meta.homepage or "";
    })
    packages;
}
