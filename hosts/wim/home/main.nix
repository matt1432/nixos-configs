{ ... }:

{
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.matt = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "uinput" "adm" "mlocate" "video" "libvirtd" ];
  };

  programs.dconf.enable = true;

  # TODO: use hm for tmux
  home-manager.users = {
    matt = {

      imports = [
        ./theme.nix
        ./hyprland.nix
        ./dotfiles.nix
        ./packages.nix

        ../../../modules/dconf.nix
        ../../../modules/firefox/main.nix
      ];

      home.stateVersion = "23.05";
    };
  };
}
