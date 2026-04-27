{
  config,
  lib,
  ...
}: let
  inherit (lib) concatStringsSep elemAt mkIf mkOption types;

  cfg = config.services.kmscon;
in {
  # FIXME: wait for https://github.com/NixOS/nixpkgs/commit/192343cd24bdd5edb86a9a7df81c037ad04753b1 to reach nixos-unstable
  imports = [./module.nix];
  disabledModules = ["services/ttys/kmscon.nix"];

  options.services.kmscon = {
    fontName = mkOption {
      type = types.str;
      default = elemAt config.fonts.fontconfig.defaultFonts.monospace 0;
    };

    fontSize = mkOption {
      type = types.numbers.nonnegative;
      default = 18;
    };
  };

  config = mkIf cfg.enable {
    services.kmscon = {
      useXkbConfig = true;
      hwRender = false;

      extraOptions = concatStringsSep " " [
        "--font-size ${toString cfg.fontSize}"
        "--font-name '${cfg.fontName}'"
      ];
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
