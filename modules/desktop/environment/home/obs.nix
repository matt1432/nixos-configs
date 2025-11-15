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
            wlrobs
            ;

          # FIXME: https://github.com/NixOS/nixpkgs/issues/461403
          droidcam-obs = pkgs.obs-studio-plugins.droidcam-obs.override {ffmpeg = pkgs.ffmpeg_7;};
        };
      };
    };
  };
}
