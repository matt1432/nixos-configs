{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues mkIf;

  cfg = config.roles.base;
in {
  config = mkIf cfg.enable {
    fonts = {
      fontconfig = {
        enable = true;
        defaultFonts = {
          emoji = ["Noto Color Emoji"];
          monospace = ["JetBrainsMono Nerd Font"];
          sansSerif = ["Noto Nerd Font"];
          serif = ["Noto Nerd Font"];
        };
      };

      packages = attrValues {
        jetbrainsMono = pkgs.jetbrains-mono;
        jetbrainsMonoNF = pkgs.nerd-fonts.jetbrains-mono;

        inherit
          (pkgs)
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-emoji
          liberation_ttf
          font-awesome
          meslo-lgs-nf
          ubuntu_font_family
          ;

        inherit
          (pkgs.nerd-fonts)
          go-mono
          iosevka
          symbols-only
          space-mono
          ubuntu
          noto
          ;
      };
    };

    # Select internationalisation properties.
    i18n.defaultLocale = "en_CA.UTF-8";
    console.useXkbConfig = true;
  };

  # For accurate stack trace
  _file = ./default.nix;
}
