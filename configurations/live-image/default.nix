{
  mainUser,
  nixpkgs,
  self,
  ...
}: {
  # ------------------------------------------------
  # Imports
  # ------------------------------------------------
  imports = [
    "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

    self.nixosModules.base
    self.nixosModules.server
  ];

  # ------------------------------------------------
  # `Self` Modules configuration
  # ------------------------------------------------
  roles.base = {
    enable = true;
    user = mainUser;
  };

  roles.server = {
    user = mainUser;
    sshd.enable = true;
  };

  services.kmscon.enable = true;

  home-manager.users.${mainUser} = {
    imports = [
      self.homeManagerModules.neovim
      self.homeManagerModules.shell
    ];

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
  };
}
