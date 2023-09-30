{ home-manager,  ... }:

{
## Global config to add home-manager module
#############################################################################
  imports = [
    home-manager.nixosModules.default
  ];

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.matt = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "uinput" "adm" "mlocate" "video" "libvirtd" ];
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  programs.dconf.enable = true;
#############################################################################

  home-manager.users.matt = {

    imports = [
      ./hyprland.nix
      ./bashdots.nix
      ./dotfiles.nix
      ./packages.nix
      ./misc.nix
      ./nvim.nix
    ];

    home.stateVersion = "23.05";
  };
}
