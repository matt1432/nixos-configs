{config, pkgs, ...}:

{
  # List packages in root user PATH
  environment.systemPackages = with pkgs; [
    wl-clipboard
    alsa-utils
    wget
    tree
    rsync
    killall
    ripgrep-all
    neovim # TODO: use nix
    imagemagick
    usbutils
    evtest
    plasma5Packages.kio-admin
    plasma5Packages.ksshaskpass
  ];

  fonts = {
    fontconfig = {
      enable = true;
      /*defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "MesloLGS Nerd Font" ];
        sansSerif = [ "MesloLGS Nerd Font" ];
        serif = [ "MesloLGS Nerd Font" ];
      };*/
    };
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" "Go-Mono" "Iosevka" "NerdFontsSymbolsOnly" "SpaceMono" "Ubuntu" ]; })
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
}
