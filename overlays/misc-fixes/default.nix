final: prev: {
  # FIXME: missing dep
  spotifywm = prev.spotifywm.overrideAttrs (o: {
    buildInputs = o.buildInputs ++ [final.libxcb];
  });

  # FIXME: remove when it reaches nixpkgs
  whoogle-search = prev.whoogle-search.overridePythonAttrs (o: rec {
    version = "0.9.4";
    src = final.fetchPypi {
      pname = "whoogle_search";
      inherit version;
      hash = "sha256-EvmNDU1hRUIy+CTwECLzIdcEjzcJgiiFYd2iMy0wDG0=";
    };
  });

  # FIXME: https://github.com/NixOS/nixpkgs/pull/443076
  hyprlandPlugins =
    prev.hyprlandPlugins
    // {
      mkHyprlandPlugin = hyprland: attrs: (prev.hyprlandPlugins.mkHyprlandPlugin (attrs // {inherit hyprland;}));
    };
}
