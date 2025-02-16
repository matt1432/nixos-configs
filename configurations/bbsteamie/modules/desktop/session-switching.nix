defaultSession: {
  config,
  lib,
  mainUser,
  pkgs,
  ...
}: {
  config = let
    inherit (lib) findFirst getExe mkForce;

    restartNetwork = getExe (pkgs.writeShellApplication {
      name = "restart-network";
      runtimeInputs = with pkgs; [systemd];
      text = "systemctl restart NetworkManager";
    });

    switch-session = pkgs.writeShellApplication {
      name = "switch-session";

      text = ''
        mkdir -p /etc/sddm.conf.d

        cat <<EOF | tee /etc/sddm.conf.d/autologin.conf
        [Autologin]
        User=${mainUser}
        Session=$1
        Relogin=true
        EOF
      '';
    };

    gaming-mode = pkgs.writeShellScriptBin "gaming-mode" ''
      sudo ${pkgs.systemd}/bin/systemctl start to-gaming-mode.service
    '';
  in {
    services.displayManager.sddm = {
      enable = true;
      autoLogin.relogin = true;

      wayland = {
        enable = true;
        compositorCommand = "kwin";
      };
    };

    # Sets the default session at launch
    systemd.services."set-session" = {
      wantedBy = ["multi-user.target"];
      before = ["display-manager.service"];

      path = [switch-session];

      script = ''
        switch-session "${defaultSession}"
      '';
    };

    # Allows switching to gaming mode
    systemd.services."to-gaming-mode" = {
      wantedBy = mkForce [];

      path = [switch-session];

      script = ''
        switch-session "gamescope-wayland"
        systemctl restart display-manager
        sleep 10
        switch-session "${defaultSession}"
      '';
    };

    security.sudo.extraRules = [
      {
        users = [mainUser];
        groups = [100];
        commands = [
          # Make it so we don't need root to switch to gaming mode
          {
            command = "${pkgs.systemd}/bin/systemctl start to-gaming-mode.service";
            options = ["SETENV" "NOPASSWD"];
          }
          # Make it so we don't need root to restart the network on launch
          {
            command = restartNetwork;
            options = ["SETENV" "NOPASSWD"];
          }
        ];
      }
    ];

    home-manager.users.${mainUser} = {
      # Add desktop entry to make it GUI friendly
      xdg.desktopEntries."Gaming Mode" = {
        name = "Gaming Mode";
        exec = getExe gaming-mode;
        icon = "steam";
        terminal = false;
        type = "Application";
      };

      home.file."Desktop/Gaming Mode.desktop".source =
        (
          findFirst
          (x: x.meta.name == "Gaming Mode.desktop") {}
          config.home-manager.users.mariah.home.packages
        )
        + "/share/applications/Gaming Mode.desktop";

      # Fix remote control prompt showing up everytime
      xdg.configFile = let
        mkAutostart = name: exe: {
          "autostart/${name}.desktop".text = "[Desktop Entry]\nType=Application\nExec=${exe}";
        };
      in (
        (mkAutostart "restart-network" "sudo ${restartNetwork}")
        // (mkAutostart "steam" "steam -silent %U")
        // (mkAutostart "krfb" "krfb --nodialog %c")
        // (mkAutostart "kde-authorize-steam" (getExe (pkgs.writeShellApplication {
          name = "kde-authorize-steam";
          text = ''
            flatpak permission-set kde-authorized remote-desktop org.kde.krdpserver yes
            flatpak permission-set kde-authorized remote-desktop "" yes
          '';
        })))
      );
    };
  };

  # For accurate stack trace
  _file = ./session-switching.nix;
}
