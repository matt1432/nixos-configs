{
  mainUser,
  self,
  wsl,
  ...
}: {
  # ------------------------------------------------
  # Imports
  # ------------------------------------------------
  imports = [
    ./modules

    wsl.nixosModules.default

    self.nixosModules.base
    self.nixosModules.docker
    self.nixosModules.meta
  ];

  # State Version: DO NOT CHANGE
  system.stateVersion = "26.11";

  # ------------------------------------------------
  # User Settings
  # ------------------------------------------------
  wsl.enable = true;
  wsl.defaultUser = mainUser;

  # https://nix-community.github.io/NixOS-WSL/how-to/vscode.html
  programs.nix-ld.enable = true;

  users.users.${mainUser} = {
    isNormalUser = true;

    # https://github.com/nix-community/NixOS-WSL/issues/1074#issuecomment-5343521462
    uid = 1042;

    hashedPassword = "$y$j9T$b.ohsX3rnaSggD68CC3vC/$A7v2UMEA/QOfY9YQEtyrwx6.5qwC6rad5v1Of82FuY3";

    extraGroups = [
      "docker"
      "wheel"
    ];
  };

  networking.hostName = "ouessel";

  time.timeZone = "America/Montreal";

  # ------------------------------------------------
  # `Self` Modules configuration
  # ------------------------------------------------
  meta = {
    roleDescription = "WSL on Work Laptop";
    hardwareDescription = "ThinkPad E14 Gen 6 Intel";
  };

  roles.base = {
    enable = true;
    user = mainUser;
  };

  roles.docker = {
    enable = true;
    storageDriver = null;
  };

  home-manager.sharedModules = [
    self.homeManagerModules.neovim
    self.homeManagerModules.shell

    {
      programs = {
        bash = {
          enable = true;
          enableNvm = true;
          promptMainColor = "blue";
        };

        neovim = {
          enable = true;
          user = mainUser;
        };
      };
    }
  ];
}
