{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) attrValues mkIf;

  cfg = osConfig.roles.desktop;
in {
  config = mkIf cfg.enable {
    programs = {
      obs-studio = {
        enable = true;
        plugins = attrValues {
          inherit
            (pkgs.obs-studio-plugins)
            droidcam-obs
            wlrobs
            ;
        };
      };
    };
  };
}
