{
  mainUser,
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
    self.nixosModules.desktop
    self.nixosModules.kmscon
    self.nixosModules.meta
    self.nixosModules.server
  ];

  # State Version: DO NOT CHANGE
  system.stateVersion = "23.11";

  # ------------------------------------------------
  # User Settings
  # ------------------------------------------------
  users.users.${mainUser} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input"
      "uinput"
      "adm"
      "video"
      "libvirtd"
      "adbusers"
    ];
  };

  programs.adb.enable = true;

  networking = {
    hostName = "binto";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  time.timeZone = "America/Montreal";

  # ------------------------------------------------
  # `Self` Modules configuration
  # ------------------------------------------------
  meta = {
    roleDescription = "Desktop PC with a multi-monitor setup";
    hardwareDescription = "NVIDIA 3070 with Ryzen 7 3700X";
  };

  roles.base = {
    enable = true;
    user = mainUser;
  };

  roles.desktop = {
    enable = true;
    user = mainUser;

    ags.enable = true;
    mainMonitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G27QC 0x00000B1D";

    fontSize = 12.5;
  };

  roles.server = {
    enable = true;
    user = mainUser;
    tailscale.enable = true;
    sshd.enable = true;
  };

  services.kmscon.enable = true;

  home-manager.users.${mainUser} = {
    imports = [
      self.homeManagerModules.firefox
      self.homeManagerModules.neovim
      self.homeManagerModules.shell
    ];

    programs = {
      bash = {
        enable = true;
        promptMainColor = "purple";
      };

      firefox.enableCustomConf = true;

      neovim = {
        enable = true;
        user = mainUser;
      };
    };
  };
}
