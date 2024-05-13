{
  config,
  hypridle,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.vars) mainUser;

  isLaptop = config.services.logind.lidSwitch == "lock";
in {
  imports = [
    ../greetd
  ];

  services.gnome.gnome-keyring.enable = true;

  home-manager.users.${mainUser} = let
    hmCfg = config.home-manager.users.${mainUser};
    lockPkg = pkgs.writeShellApplication {
      name = "lock";
      runtimeInputs = [
        hmCfg.programs.ags.finalPackage
      ];
      text = ''
        ags -r 'Tablet.setLaptopMode()'
        ags -b lockscreen -c /home/${mainUser}/.config/ags/lockscreen.js
      '';
    };
  in {
    home.packages = [
      pkgs.gnome.seahorse
      lockPkg
    ];

    services.hypridle = mkIf isLaptop {
      enable = true;
      settings.general.lock_cmd = "${lockPkg}/bin/lock";
    };

    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [
          "gnome-keyring-daemon --start --components=secrets"
          "${pkgs.plasma5Packages.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
        ];

        windowrule = [
          "float,^(org.kde.polkit-kde-authentication-agent-1)$"
          "size 741 288,^(org.kde.polkit-kde-authentication-agent-1)$"
          "center,^(org.kde.polkit-kde-authentication-agent-1)$"

          # For GParted auth
          "size 741 288,^(org.kde.ksshaskpass)$"
          "move cursor -370 -144,^(org.kde.ksshaskpass)$"
        ];

        bind = [
          "$mainMod, L, exec, ${lockPkg}/bin/lock"
        ];
      };
    };
  };
}
