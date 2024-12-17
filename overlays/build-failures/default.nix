final: prev: {
  # FIXME: https://pr-tracker.nelim.org/?pr=357699
  nodejs_latest = prev.nodejs_22;

  # FIXME: https://pr-tracker.nelim.org/?pr=365776
  hyprlandPlugins =
    prev.hyprlandPlugins
    // {
      mkHyprlandPlugin = hyprland: args @ {pluginName, ...}:
        hyprland.stdenv.mkDerivation (
          args
          // {
            pname = "${pluginName}";
            nativeBuildInputs = [final.pkg-config] ++ args.nativeBuildInputs or [];
            buildInputs = [hyprland] ++ hyprland.buildInputs ++ (args.buildInputs or []);
            meta =
              args.meta
              // {
                description = args.meta.description or "";
                longDescription =
                  (args.meta.longDescription or "")
                  + "\n\nPlugins can be installed via a plugin entry in the Hyprland NixOS or Home Manager options.";
              };
          }
        );
    };
}
