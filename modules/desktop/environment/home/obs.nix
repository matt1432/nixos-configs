{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.roles.desktop;
in {
  config = mkIf cfg.enable {
    programs = {
      obs-studio = {
        enable = true;
        plugins = [
          pkgs.waylandPkgs.obs-wlrobs
          pkgs.obs-studio-plugins.droidcam-obs
        ];
      };
    };
  };
}
