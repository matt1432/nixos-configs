self: {pkgs, ...}: let
  inherit (self.inputs) nixpkgs-wayland;
in {
  config = let
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
  };

  # For accurate stack trace
  _file = ./obs.nix;
}
