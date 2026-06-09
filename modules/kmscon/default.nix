{
  config,
  lib,
  ...
}: let
  inherit (lib) elemAt mkIf;

  cfg = config.services.kmscon;
in {
  config = mkIf cfg.enable {
    services.kmscon = {
      useXkbConfig = true;

      config = {
        font-name = elemAt config.fonts.fontconfig.defaultFonts.monospace 0;
        font-size = 18;
        hwaccel = false;
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
