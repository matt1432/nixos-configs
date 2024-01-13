{
  ags,
  config,
  pkgs,
  ...
}: let
  inherit (config.vars) configDir mainUser;
  isTouchscreen = config.hardware.sensor.iio.enable;
in {
  services.upower.enable = true;

  home-manager.users.${mainUser}.imports = [
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
        configDir = symlink "${configDir}/ags";
        package = ags.packages.${pkgs.system}.default;
        extraPackages = with pkgs; [
          libgudev
        ];
      };

      home.packages =
        [config.customPkgs.coloryou]
        ++ (with pkgs; [
          # ags
          sassc
          bun
          playerctl

          ## gui
          pavucontrol # TODO: replace with ags widget
        ])
        ++ (optionals isTouchscreen (with pkgs; [
          lisgd
          squeekboard
          ydotool
        ]));
    })
  ];
}
