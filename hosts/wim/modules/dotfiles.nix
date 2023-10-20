{ config, pkgs, ... }: let
  configDir = config.services.hostvars.configDir;
  symlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  xdg.configFile = {
    "swayosd/style.css".source     = symlink "${configDir}/swayosd/style.css";

    "gtklock/config.ini".source    = pkgs.writeText "config.ini" ''
      [main]
      modules=${builtins.concatStringsSep ";" [
        "${pkgs.gtklock-powerbar-module}/lib/gtklock/powerbar-module.so"
        "${pkgs.gtklock-playerctl-module}/lib/gtklock/playerctl-module.so"
      ]}
                                    '';
    "gtklock/style.css".source     = symlink "${configDir}/gtklock/style.css";

    "dolphinrc".source             = symlink "${configDir}/dolphinrc";
    "kdeglobals".source            = symlink "${configDir}/kdeglobals";
    "kiorc".source                 = symlink "${configDir}/kiorc";
    "mimeapps.list".source         = symlink "${configDir}/mimeapps.list";
    "neofetch".source              = symlink "${configDir}/neofetch";
    "swappy".source                = symlink "${configDir}/swappy";
  };
}
