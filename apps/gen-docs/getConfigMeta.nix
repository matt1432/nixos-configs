configs: let
  inherit (builtins) mapAttrs replaceStrings;

  trimNewlines = s: replaceStrings ["\n"] [" "] s;
in {
  attrs =
    mapAttrs (_: v: {
      roleDesc = trimNewlines (v.config.meta.roleDescription or "");
      hwDesc = trimNewlines (v.config.meta.hardwareDescription or "");
    })
    configs;
}
