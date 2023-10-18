{ config, pkgs, nixpkgs-wayland, ... }: let
  waypkgs = nixpkgs-wayland.packages.x86_64-linux;

  configDir = (import ../vars.nix).configDir;
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

    "discord/settings.json".source = symlink "${configDir}/discord/settings.json";

    "dolphinrc".source             = symlink "${configDir}/dolphinrc";
    "kdeglobals".source            = symlink "${configDir}/kdeglobals";
    "kiorc".source                 = symlink "${configDir}/kiorc";
    "mimeapps.list".source         = symlink "${configDir}/mimeapps.list";
    "neofetch".source              = symlink "${configDir}/neofetch";
    "swappy".source                = symlink "${configDir}/swappy";
  };

  programs = {
    wofi = {
      enable = true;
      package = waypkgs.wofi;
      settings = {
        prompt = "";
        allow_images = true;
        normal_window = true;
        image_size = "48";
        matching = "fuzzy";
        insensitive = true;
        no_actions = true;
      };
      style = builtins.readFile ../config/wofi/style.css;
    };
  };
}
