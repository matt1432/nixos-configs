{ home-manager, nur, ... }:

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

  programs.dconf.enable = true;
#############################################################################

  # TODO: use hm for tmux
  home-manager.users = {
    matt = {

      imports = [
        nur.hmModules.nur
        ./dconf.nix
        ./theme.nix
        ./hyprland.nix
        ./dotfiles.nix
        ./packages.nix
        ./firefox/main.nix
      ];

      home.stateVersion = "23.05";
    };
  };
}
