{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe mkForce;
  inherit (config.vars) mainUser;

  # FIXME: switch to wayland once plasma 6.1.1 releases
  defaultSession = "plasmax11";

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
    xserver.enable = true;
    desktopManager.plasma6.enable = true;

    displayManager = {
      sddm = {
        enable = true;
        autoLogin.relogin = true;
      };
    };
  };

  systemd.services."set-session" = {
    wantedBy = ["multi-user.target"];
    before = ["display-manager.service"];

    path = [switch-session];

    script = ''
      switch-session "${defaultSession}"
    '';
  };

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
        {
          command = "${pkgs.systemd}/bin/systemctl start to-gaming-mode.service";
          options = ["SETENV" "NOPASSWD"];
        }
      ];
    }
  ];

  home-manager.users.${mainUser}.xdg.desktopEntries."Gaming Mode" = {
    name = "Gaming Mode";
    exec = getExe gaming-mode;
    icon = "steam";
    terminal = false;
    type = "Application";
  };

  environment.systemPackages = [
    pkgs.firefox
    pkgs.wl-clipboard
    pkgs.ryujinx
  ];

  programs = {
    xwayland.enable = true;
    kdeconnect.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };
  };

  # Enable flatpak support
  services.flatpak.enable = true;
  services.packagekit.enable = true;
  jovian.steam = {
    enable = true;
    user = mainUser;

    desktopSession = config.services.displayManager.defaultSession;
  };

  jovian.decky-loader = {
    enable = true;
    user = mainUser;
  };

  # Takes way too long to shutdown
  systemd.services."decky-loader".serviceConfig.TimeoutStopSec = "5";
}
