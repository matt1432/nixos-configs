attr: selfPath: let
  inherit (builtins) mapAttrs replaceStrings;

  modules = import "${selfPath}/${attr}" {description = true;};

  trimNewlines = s: replaceStrings ["\n"] [" "] s;
in {
  attrs =
    mapAttrs (_: v: {
      desc = trimNewlines v;
    })
    modules;
}
