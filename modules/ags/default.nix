{
  ags,
  config,
  pkgs,
  ...
}: let
  isNvidia = config.hardware.nvidia.modesetting.enable;
  isTouchscreen = config.hardware.sensor.iio.enable;
in {
  services.upower.enable = true;

  home-manager.users.${config.vars.user}.imports = [
    ags.homeManagerModules.default

    ({
      config,
      lib,
      ...
    }: let
      symlink = config.lib.file.mkOutOfStoreSymlink;
      optionals = lib.lists.optionals;
    in {
      programs.ags = {
        enable = true;
        configDir = symlink "${config.vars.configDir}/ags";
        package = ags.packages.x86_64-linux.default;
        extraPackages = [pkgs.libgudev];
      };

      home.packages = with pkgs;
        [
          # ags
          sassc
          coloryou
          playerctl

          ## gui
          pavucontrol # TODO: replace with ags widget
          networkmanagerapplet # TODO: replace with ags widget
        ]
        ++ (optionals isTouchscreen [
          # touchscreen
          lisgd
          squeekboard
          ydotool
          blueberry
        ]);
    })
  ];
}
