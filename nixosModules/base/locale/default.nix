{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues mkIf;

  cfg = config.roles.base;
in
  mkIf cfg.enable {
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

      packages =
        [
          (pkgs.nerdfonts.override {
            fonts = [
              "JetBrainsMono"
              "Go-Mono"
              "Iosevka"
              "NerdFontsSymbolsOnly"
              "SpaceMono"
              "Ubuntu"
              "Noto"
            ];
          })
        ]
        ++ (attrValues {
          inherit
            (pkgs)
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-emoji
            liberation_ttf
            font-awesome
            meslo-lgs-nf
            jetbrains-mono
            ubuntu_font_family
            ;
        });
    };

    # Select internationalisation properties.
    i18n.defaultLocale = "en_CA.UTF-8";
    console.useXkbConfig = true;
  }
