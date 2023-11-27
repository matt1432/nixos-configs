{
  pkgs,
  config,
  ags,
  ...
}: let
  configDir = config.services.device-vars.configDir;
  symlink = config.lib.file.mkOutOfStoreSymlink;
in {
  imports = [
    ags.homeManagerModules.default
  ];

  programs.ags = {
    enable = true;
    configDir = symlink "${configDir}/ags";
    package = ags.packages.x86_64-linux.default;
    extraPackages = [pkgs.libgudev];
  };

  home.packages = with pkgs; [
    # ags
    sassc
    coloryou
    playerctl

    ## gui
    pavucontrol # TODO: replace with ags widget
    networkmanagerapplet # TODO: replace with ags widget
  ];
}
