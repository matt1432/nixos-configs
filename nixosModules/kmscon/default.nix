{
  config,
  lib,
  ...
}: let
  inherit (lib) elemAt mkIf mkOption types;

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
      default = 170;
    };
  };

  config = mkIf cfg.enable {
    services.kmscon = {
      useXkbConfig = true;
      hwRender = false;

      # FIXME: https://github.com/Aetf/kmscon/issues/18    // Icons not rendering properly
      extraOptions = builtins.concatStringsSep " " [
        "--font-size ${toString cfg.fontSize}"
        "--font-dpi ${toString cfg.fontDpi}"
        "--font-name '${cfg.fontName}'"
      ];
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
