{ ... }:

{
  users.users.matt = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "uinput" "adm" "mlocate" "video" "libvirtd" ];
  };

  programs.dconf.enable = true;

  # TODO: use hm for tmux
  home-manager.users = {
    matt = {

      imports = [
        ../wim/home/dconf.nix
        ../wim/home/firefox/main.nix
      ];

      home.stateVersion = "23.11";
    };
  };
}
