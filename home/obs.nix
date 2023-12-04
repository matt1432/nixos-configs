{nixpkgs-wayland, ...}: let
  waypkgs = nixpkgs-wayland.packages.x86_64-linux;
in {
  programs = {
    obs-studio = {
      enable = true;
      plugins = with waypkgs; [
        obs-wlrobs
      ];
    };
  };
}
