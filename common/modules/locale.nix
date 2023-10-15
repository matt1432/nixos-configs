{ pkgs, ... }: {
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "JetBrainsMono Nerd Font" ];
        serif = [ "JetBrainsMono Nerd Font" ];
      };
    };

    packages = with pkgs; [
      (nerdfonts.override { fonts = [
        "JetBrainsMono"
        "Go-Mono"
        "Iosevka"
        "NerdFontsSymbolsOnly"
        "SpaceMono"
        "Ubuntu"
      ]; })
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
  console = {
    keyMap = "ca";
  };
}
