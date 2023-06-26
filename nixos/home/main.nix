{ config, pkgs,  ... }:

{
## Global config to add home-manager module
#############################################################################
  imports =
    [
      <home-manager/nixos>
    ];

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.matt = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "adm" "mlocate" "video" ];
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  programs.dconf.enable = true;
#############################################################################

  home-manager.users.matt = {

    imports = [
      ./bashdots.nix
      ./hyprland.nix
      ./packages.nix
      ./misc.nix
    ];

    home.stateVersion = "23.05";
  };
}
