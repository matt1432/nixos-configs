{config, ...}: let
  configDir = config.vars.configDir;
  symlink = config.lib.file.mkOutOfStoreSymlink;
in {
  wayland.windowManager.hyprland = {
    settings = {
      env = [
        "AGS_PATH, ${configDir}/ags/bin"
        "HYPR_PATH, ${configDir}/hypr/scripts"
      ];
    };
  };

  xdg.configFile = {
    "dolphinrc".source = symlink "${configDir}/dolphinrc";
    "kdeglobals".source = symlink "${configDir}/kdeglobals";
    "kiorc".source = symlink "${configDir}/kiorc";
    "mimeapps.list".source = symlink "${configDir}/mimeapps.list";
    "neofetch".source = symlink "${configDir}/neofetch";
    "swappy".source = symlink "${configDir}/swappy";
  };
}
