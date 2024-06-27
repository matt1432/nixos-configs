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
      plugins = with waypkgs; [
        obs-wlrobs
      ];
    };
  };
}
