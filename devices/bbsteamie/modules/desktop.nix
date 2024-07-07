{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib) getExe mkForce;
  inherit (config.vars) mainUser;

  # FIXME: switch to wayland when possible
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

  environment.systemPackages = [
    # Misc apps for DE
    pkgs.firefox
    pkgs.kdePackages.discover
    pkgs.wl-clipboard

    # FIXME:Ryujinx ACNH crashes on OpenGL AND Vulkan
    # https://github.com/Ryujinx/Ryujinx/issues/6993
    # https://github.com/Ryujinx/Ryujinx/issues/6708
    self.packages.${pkgs.system}.yuzu
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

  # Jovian NixOS settings
  jovian.steam = {
    # Steam > Settings > System > Enable Developer Mode
    # Steam > Developer > CEF Remote Debugging
    enable = true;
    user = mainUser;

    desktopSession = config.services.displayManager.defaultSession;
  };

  jovian.decky-loader = {
    enable = true;
    user = mainUser;
    stateDir = "/home/${mainUser}/.local/share/decky"; # Keep scoped to user
    # https://github.com/Jovian-Experiments/Jovian-NixOS/blob/1171169117f63f1de9ef2ea36efd8dcf377c6d5a/modules/decky-loader.nix#L80-L84

    extraPackages = with pkgs; [
      # Generic packages
      curl
      unzip
      util-linux
      gnugrep

      readline.out
      procps
      pciutils
      libpulseaudio
    ];

    extraPythonPackages = pythonPackages:
      with pythonPackages; [
        python
      ];
  };

  # Takes way too long to shutdown
  systemd.services."decky-loader".serviceConfig.TimeoutStopSec = "5";
}
