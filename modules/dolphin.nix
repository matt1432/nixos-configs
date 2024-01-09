{
  config,
  pkgs,
  ...
}: let
  inherit (config.vars) mainUser;
in {
  environment.systemPackages = with pkgs; [
    plasma5Packages.kio-admin
  ];

  home-manager.users.${mainUser}.home.packages = with pkgs;
    []
    ++ (with pkgs.plasma5Packages; [
      ark
      kcharselect
      kdenlive
      okular

      # Dolphin & co
      dolphin
      dolphin-plugins
      kdegraphics-thumbnailers
      ffmpegthumbs
      kio
      kio-admin # needs to be both here and in system pkgs
      kio-extras
      kmime
    ])
    ++ (with pkgs.gnome; [
      gnome-calculator
    ]);
}
