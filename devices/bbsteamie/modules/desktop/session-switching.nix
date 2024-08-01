defaultSession: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe mkForce;

  inherit (config.vars) mainUser;

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
  services = {
    displayManager = {
      sddm = {
        enable = true;
        autoLogin.relogin = true;

        wayland = {
          enable = true;
          compositorCommand = "kwin";
        };
      };
    };

    xserver.enable = true;
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

  # Make it so we don't need root to switch to gaming mode
  security.sudo.extraRules = [
    {
      users = [mainUser];
      groups = [100];
      commands = [
        {
          command = "${pkgs.systemd}/bin/systemctl start to-gaming-mode.service";
          options = ["SETENV" "NOPASSWD"];
        }
      ];
    }
  ];

  # Add desktop entry to make it GUI friendly
  home-manager.users.${mainUser}.xdg.desktopEntries."Gaming Mode" = {
    name = "Gaming Mode";
    exec = getExe gaming-mode;
    icon = "steam";
    terminal = false;
    type = "Application";
  };
}
