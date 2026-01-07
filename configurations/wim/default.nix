{
  mainUser,
  self,
  pkgs,
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
    self.nixosModules.docker
    self.nixosModules.kmscon
    self.nixosModules.meta
    self.nixosModules.plymouth
    self.nixosModules.server
  ];

  # State Version: DO NOT CHANGE
  system.stateVersion = "23.05";

  # ------------------------------------------------
  # User Settings
  # ------------------------------------------------
  users.users.${mainUser} = {
    isNormalUser = true;
    uid = 1000;

    hashedPassword = "$y$j9T$ZwnaqAzFjKB/1oJSvypdt.$CtQzgoUWxNutP1DsTBrFHXiTGP6JJp/bMchl1VaADSA";

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

  environment.systemPackages = [pkgs.android-tools];

  networking = {
    hostName = "wim";
    networkmanager = {
      enable = true;

      wifi = {
        backend = "wpa_supplicant";
        scanRandMacAddress = false;
      };
    };
    firewall.enable = false;
  };

  time.timeZone = "America/Montreal";

  # ------------------------------------------------
  # `Self` Modules configuration
  # ------------------------------------------------
  meta = {
    roleDescription = "2-1 Lenovo Laptop that I use for university";
    hardwareDescription = "ThinkPad L13 Yoga Gen 3 (Ryzen 7 PRO 5875U)";
  };

  roles.base = {
    enable = true;
    user = mainUser;
  };

  roles.desktop = {
    enable = true;
    user = mainUser;

    ags.enable = true;
    quickshell.enable = true;
    mainMonitor = "eDP-1";
    isLaptop = true;
    isTouchscreen = true;

    fontSize = 12.5;
  };

  roles.server = {
    enable = true;
    user = mainUser;
    tailscale.enable = true;
  };

  roles.docker.enable = true;

  boot.plymouth = {
    enable = true;
    theme = "dracula";
    themePackages = [
      pkgs.scopedPackages.dracula.plymouth
    ];
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
