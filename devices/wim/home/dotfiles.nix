{
  config,
  pkgs,
  ...
}: let
  configDir = config.services.device-vars.configDir;
  symlink = config.lib.file.mkOutOfStoreSymlink;
in {
  wayland.windowManager.hyprland = {
    settings = {
      env = [
        "AGS_PATH, ${configDir}/ags/bin"
        "HYPR_PATH, ${configDir}/hypr/scripts"
        "LOCK_PATH, ${configDir}/gtklock/scripts"
      ];
    };
  };

  xdg.configFile = {
    "gtklock/config.ini".text =  ''
      [main]
      modules=${builtins.concatStringsSep ";" [
        "${pkgs.gtklock-powerbar-module}/lib/gtklock/powerbar-module.so"
        "${pkgs.gtklock-playerctl-module}/lib/gtklock/playerctl-module.so"
      ]}
    '';
    "gtklock/style.css".source = symlink "${configDir}/gtklock/style.css";

    "dolphinrc".source = symlink "${configDir}/dolphinrc";
    "kdeglobals".source = symlink "${configDir}/kdeglobals";
    "kiorc".source = symlink "${configDir}/kiorc";
    "mimeapps.list".source = symlink "${configDir}/mimeapps.list";
    "neofetch".source = symlink "${configDir}/neofetch";
    "swappy".source = symlink "${configDir}/swappy";
  };
}
