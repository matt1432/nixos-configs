{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.roles.base;
in {
  config = mkIf cfg.enable {
    fonts.fontconfig = {
      enable = true;

      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = ["JetBrainsMono Nerd Font Mono"];
        sansSerif = ["Noto Nerd Font"];
        serif = ["Noto Nerd Font"];
      };
    };

    i18n.defaultLocale = "en_CA.UTF-8";
    console.useXkbConfig = true;
  };
}
