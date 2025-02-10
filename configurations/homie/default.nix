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

  # FIXME: temporary fix while I figure out the issue with the Network Card?
  systemd.services."temp-fix-nic" = {
    wantedBy = ["multi-user.target"];
    after = ["tailscaled.service"];
    path = [pkgs.ripgrep];
    script = ''
      # Wait for boot to finish
      sleep 60

      echo "start listening to journalctl"

      journalctl -fb | while read -r line; do
          if echo "$line" | rg 'NIC Link is Up' &> /dev/null; then
              echo "restarting tailscaled"
              systemctl restart tailscaled.service
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

  home-manager.users.${mainUser} = {
    imports = [
      self.homeManagerModules.neovim
      self.homeManagerModules.shell
    ];

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
  };
}
