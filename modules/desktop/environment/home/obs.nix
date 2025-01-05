self: {
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (self.inputs) nixpkgs-wayland;

  waypkgs = nixpkgs-wayland.packages.${pkgs.system};

  inherit (lib) mkIf;

  cfg = osConfig.roles.desktop;
in {
  config = mkIf cfg.enable {
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
