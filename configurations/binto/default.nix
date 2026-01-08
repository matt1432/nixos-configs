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
    uid = 1000;

    hashedPassword = "$y$j9T$uCv3kB5LI3Shj/5liU9cS0$4s3wWoH4iY29DLC3lJwNaIcurcjsj8L02cMY4EDtnC6";

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
    mainMonitor = "DP-2";

    fontSize = 12.5;
  };

  roles.server = {
    enable = true;
    user = mainUser;
    tailscale.enable = true;
    sshd.enable = true;
  };

  services.kmscon.enable = true;

  home-manager.sharedModules = [
    self.homeManagerModules.neovim
    self.homeManagerModules.shell

    {
      programs = {
        bash = {
          enable = true;
          promptMainColor = "purple";
        };
        neovim = {
          enable = true;
          user = mainUser;
        };
      };
    }
  ];

  home-manager.users.${mainUser} = {
    imports = [
      self.homeManagerModules.firefox
    ];

    programs = {
      firefox.enableCustomConf = true;
    };
  };
}
