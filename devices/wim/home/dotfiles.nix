{config, ...}: let
  configDir = config.vars.configDir;
  symlink = config.lib.file.mkOutOfStoreSymlink;
in {
  xdg.configFile = {
    "dolphinrc".source = symlink "${configDir}/dolphinrc";
    "kdeglobals".source = symlink "${configDir}/kdeglobals";
    "kiorc".source = symlink "${configDir}/kiorc";
    "mimeapps.list".source = symlink "${configDir}/mimeapps.list";
    "neofetch".source = symlink "${configDir}/neofetch";
    "swappy".source = symlink "${configDir}/swappy";
  };
}
