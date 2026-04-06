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
    fonts.packages = attrValues {
      jetbrainsMono = pkgs.jetbrains-mono;
      jetbrainsMonoNF = pkgs.nerd-fonts.jetbrains-mono;

      inherit
        (pkgs)
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        liberation_ttf
        font-awesome
        meslo-lgs-nf
        ubuntu-classic
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
}
