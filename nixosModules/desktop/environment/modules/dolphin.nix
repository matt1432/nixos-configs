{
  config,
  pkgs,
  ...
}: {
  config = let
    cfg = config.roles.desktop;
  in {
    environment.systemPackages = with pkgs; [
      plasma5Packages.kio-admin
    ];

    # To make it work with firefox
    # https://www.reddit.com/r/NixOS/comments/xtoubc/comment/koxxr3e/?utm_source=share&utm_medium=web2x&context=3
    systemd.user.services.plasma-dolphin = {
      unitConfig = {
        Description = "Dolphin file manager";
        PartOf = ["graphical-session.target"];
      };
      path = ["/run/current-system/sw"];
      environment.QT_QPA_PLATFORM = "wayland";
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.FileManager1";
        ExecStart = "${pkgs.dolphin}/bin/dolphin";
      };
    };

    home-manager.users.${cfg.user}.home.packages = with pkgs;
      [
        gnome-calculator
      ]
      ++ (with kdePackages; [
        kde-cli-tools
      ])
      ++ (with plasma5Packages; [
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
      ]);
  };

  # For accurate stack trace
  _file = ./dolphin.nix;
}
