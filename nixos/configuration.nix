{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./cfg/boot.nix
      ./cfg/security.nix
      ./cfg/extra-hardware.nix
      ./overlays/list.nix
      ./cfg/home-manager.nix
    ];

  services.xserver = {
    enable = true;
    layout = "ca";
    displayManager = {
      gdm.enable = true;
      gdm.wayland = true;
      sessionPackages = [ pkgs.hyprland ];
    };
  };

  networking.hostName = "wim";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";
  console = {
    #font = "Lat2-Terminus16";
    keyMap = "ca";
    #useXkbConfig = true; # use xkbOptions in tty.
  };

  virtualisation = {
    waydroid.enable = true;
    lxd.enable = true;
  };

  services.dbus.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ 
    pkgs.xdg-desktop-portal-hyprland
  ];
  services.flatpak.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.matt = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "adm" "mlocate" "video" ];
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wl-clipboard
    pulseaudio
    alsa-utils
    wget
    tree
    mlocate
    rsync
    tmux
    git
    git-lfs
    killall
    htop
    fzf
    jq
    ripgrep
    python3
    neovim
    imagemagick
    usbutils
    catppuccin-plymouth
    evtest
  ];

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        #emoji = [ "Noto Color Emoji" ];
        #monospace = [ "MesloLGS Nerd Font" ];
        #sansSerif = [ "MesloLGS Nerd Font" ];
        #serif = [ "MesloLGS Nerd Font" ];
      };
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
      #google-fonts
      ubuntu_font_family
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
  };

  # TODO: see if setting them in Hyprland.nix works
  environment.sessionVariables = {
    GTK_THEME 		 = "Lavanda-Dark";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE	 = "kvantum";
    QT_FONT_DPI		 = "125";
  };

  environment.variables = {
    GTK_THEME 		 = "Lavanda-Dark";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE	 = "kvantum";
    QT_FONT_DPI		 = "125";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
