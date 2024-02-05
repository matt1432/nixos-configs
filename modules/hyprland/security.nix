{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) optionals;
  inherit (config.vars) mainUser;

  isLaptop = config.services.logind.lidSwitch == "lock";
in {
  imports = [
    ../greetd
  ];

  security.pam.services.swaylock = {};
  services.gnome.gnome-keyring.enable = true;

  home-manager.users.${mainUser} = {
    imports = [
      ../../home/swaylock.nix
    ];

    home.packages = with pkgs; ([
        gnome.seahorse
      ]
      ++ optionals isLaptop [
        swayidle
      ]);

    wayland.windowManager.hyprland = {
      settings = {
        exec-once =
          [
            "gnome-keyring-daemon --start --components=secrets"
            "${pkgs.plasma5Packages.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
          ]
          ++ optionals isLaptop ["swayidle -w lock lock"];

        windowrule = [
          "float,^(org.kde.polkit-kde-authentication-agent-1)$"
          "size 741 288,^(org.kde.polkit-kde-authentication-agent-1)$"
          "center,^(org.kde.polkit-kde-authentication-agent-1)$"
        ];

        bind = [
          "$mainMod, L, exec, lock"
        ];
      };
    };
  };
}
