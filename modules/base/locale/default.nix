{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

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

      packages = with pkgs;
        [
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-emoji
          liberation_ttf
          font-awesome
          meslo-lgs-nf
          jetbrains-mono
          ubuntu_font_family
        ]
        ++ (with pkgs.nerd-fonts; [
          jetbrains-mono
          go-mono
          iosevka
          symbols-only
          space-mono
          ubuntu
          noto
        ]);
    };

    # Select internationalisation properties.
    i18n.defaultLocale = "en_CA.UTF-8";
    console.useXkbConfig = true;
  };

  # For accurate stack trace
  _file = ./default.nix;
}
