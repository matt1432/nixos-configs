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

  wayland.windowManager.hyprland = {
    settings = {
      env = [
        "AGS_PATH, ${configDir}/ags/bin"
        "HYPR_PATH, ${configDir}/hypr/scripts"
        "LOCK_PATH, ${configDir}/gtklock/scripts"
      ];
    };
  };

  home.packages = with pkgs; [
    # ags
    ydotool
    sassc
    coloryou
    libnotify
    playerctl

    ## gui
    pavucontrol # TODO: replace with ags widget
    networkmanagerapplet # TODO: replace with ags widget
    blueberry # TODO: replace with ags widget

    # touchscreen
    lisgd
    squeekboard
  ];
}
