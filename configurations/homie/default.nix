{
  mainUser,
  pkgs,
  self,
  ...
}: {
  # ------------------------------------------------
  # Imports
  # ------------------------------------------------
  imports = [
    ./hardware-configuration.nix

    ./modules

    self.nixosModules.base
    self.nixosModules.docker
    self.nixosModules.kmscon
    self.nixosModules.meta
    self.nixosModules.server
  ];

  # State Version: DO NOT CHANGE
  system.stateVersion = "24.11";

  # ------------------------------------------------
  # User Settings
  # ------------------------------------------------
  users.users.${mainUser} = {
    isNormalUser = true;
    uid = 1000;

    hashedPassword = "$y$j9T$CBC0wX9ZrZeXE296CWTvK.$xTJE54Pd4EPrv/Q4TQ42ahIDXQYoavcnwcsItw0hk.B";

    extraGroups = [
      "wheel"
      "adm"
    ];
  };

  networking = {
    hostName = "homie";
    resolvconf.enable = true;
    firewall.enable = false;
  };

  # temporary fix while I figure out the issue with the Network Card
  systemd.services."temp-fix-nic" = {
    wantedBy = ["multi-user.target"];
    after = ["tailscaled.service"];
    path = [pkgs.ripgrep pkgs.systemd "/run/wrappers"];
    script = ''
      # Wait for boot to finish
      sleep 60

      echo "start listening to journalctl"

      journalctl -fb | while read -r line; do
          if echo "$line" | rg 'NIC Link is Up' &> /dev/null; then
              echo "restarting tailscaled"
              systemctl restart tailscaled.service
              machinectl shell ${mainUser}@ ${pkgs.systemd}/bin/systemctl --user restart spotifyd
          fi
      done
    '';
    serviceConfig = {
      User = "root";
      AmbientCapabilities = "CAP_SYS_ADMIN CAP_SYSLOG";
    };
  };

  time.timeZone = "America/Montreal";

  # ------------------------------------------------
  # `Self` Modules configuration
  # ------------------------------------------------
  meta = {
    roleDescription = "Mini PC that serves as a Home-assistant server";
    hardwareDescription = "Lenovo Thinkcentre M910q";
  };

  roles.base = {
    enable = true;
    user = mainUser;
  };

  roles.server = {
    enable = true;
    user = mainUser;
    tailscale.enable = true;
    sshd.enable = true;
  };

  roles.docker.enable = true;

  services.kmscon.enable = true;

  home-manager.sharedModules = [
    self.homeManagerModules.neovim
    self.homeManagerModules.shell

    {
      programs = {
        bash = {
          enable = true;
          promptMainColor = "yellow";
        };

        neovim = {
          enable = true;
          user = mainUser;
        };
      };
    }
  ];
}
