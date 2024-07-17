{
  nixpkgs-wayland,
  pkgs,
  ...
}: let
  waypkgs = nixpkgs-wayland.packages.${pkgs.system};
in {
  programs = {
    obs-studio = {
      enable = true;
      plugins = [
        waypkgs.obs-wlrobs
        pkgs.obs-studio-plugins.droidcam-obs
      ];
    };
  };
}
