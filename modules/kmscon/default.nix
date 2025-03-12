{
  config,
  lib,
  ...
}: let
  inherit (lib) concatStringsSep elemAt mkIf mkOption types;

  cfg = config.services.kmscon;
in {
  options.services.kmscon = {
    fontName = mkOption {
      type = types.str;
      default = elemAt config.fonts.fontconfig.defaultFonts.monospace 0;
    };

    fontSize = mkOption {
      type = types.numbers.nonnegative;
      default = 12.5;
    };

    fontDpi = mkOption {
      type = types.numbers.nonnegative;
      default = 130;
    };
  };

  config = mkIf cfg.enable {
    services.kmscon = {
      useXkbConfig = true;
      hwRender = false;

      extraOptions = concatStringsSep " " [
        "--font-size ${toString cfg.fontSize}"
        "--font-dpi ${toString cfg.fontDpi}"
        "--font-name '${cfg.fontName}'"
      ];
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
