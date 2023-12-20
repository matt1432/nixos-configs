{pkgs, ...}: {
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = ["Noto Nerd Font"];
        sansSerif = ["Noto Nerd Font"];
        serif = ["Noto Nerd Font"];
      };
    };

    packages = with pkgs; [
      (nerdfonts.override {
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
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      font-awesome
      meslo-lgs-nf
      jetbrains-mono
      ubuntu_font_family
    ];
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";
  console.useXkbConfig = true;
}
