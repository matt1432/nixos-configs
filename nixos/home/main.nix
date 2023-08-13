{ config, pkgs,  ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
## Global config to add home-manager module
#############################################################################
  imports =
    [
      (import "${home-manager}/nixos")
    ];

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.matt = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "uinput" "adm" "mlocate" "video" ];
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
