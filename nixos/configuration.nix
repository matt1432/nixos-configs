# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
#      ./cfg/Hyprland.nix
    ];

  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    initrd.systemd.enable = true;

    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        extraConfig = ''
          set timeout_style=hidden
        '';
        # Because it still draws that image otherwise
        splashImage = null;
      };
      timeout = 2;
    };

    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "i915.fastboot=1"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "cryptdevice=UUID=ab82b477-2477-453f-b95f-28e5553ad10d:root"
      "root=/dev/mapper/root"
    ];

    plymouth = {
      enable = true;
      themePackages = [ pkgs.catppuccin-plymouth ];
      theme = "catppuccin-macchiato";
    };
  };

  services.xserver = {
    enable = true;
    displayManager = {
      gdm.enable = true;
      gdm.wayland = true;
      sessionPackages = [ pkgs.hyprland ];
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;
  programs.dconf.enable = true;

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness'"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness'"
  '';

  services.fprintd.enable = true;

  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  security.pam.services.sddm.text = ''
    auth      [success=1 new_authtok_reqd=1 default=ignore]  	pam_unix.so try_first_pass likeauth nullok
    auth      sufficient    /nix/store/7hw6i2p2p7zzgjirw6xaj3c50gga488y-fprintd-1.94.2/lib/security/pam_fprintd.so
    auth      substack      login
    account   include       login
    password  substack      login
    session   include       login
  '';

  security.pam.services.sudo.text = ''
    # Account management.
    auth    sufficient    /root/lib/pam/pam_fprintd_grosshack.so
    auth    sufficient    pam_unix.so try_first_pass nullok
    account required pam_unix.so

    # Authentication management.
    auth required pam_deny.so

    # Password management.
    password sufficient pam_unix.so nullok yescrypt

    # Session management.
    session required pam_env.so conffile=/etc/pam/environment readenv=0
    session required pam_unix.so
  '';

  security.pam.services.login.text = ''
    # Account management.
    account required pam_unix.so

    # Authentication management.
    auth    sufficient    /root/lib/pam/pam_fprintd_grosshack.so
    auth optional pam_unix.so nullok  likeauth
    auth optional /nix/store/21dqfghfa8b09ssvgja8l5bg7h5d9rzl-gnome-keyring-42.1/lib/security/pam_gnome_keyring.so
    auth    sufficient    pam_unix.so try_first_pass nullok
    auth required pam_deny.so

    # Password management.
    password sufficient pam_unix.so nullok yescrypt
    password optional /nix/store/21dqfghfa8b09ssvgja8l5bg7h5d9rzl-gnome-keyring-42.1/lib/security/pam_gnome_keyring.so use_authtok

    # Session management.
    session required pam_env.so conffile=/etc/pam/environment readenv=0
    session required pam_unix.so
    session required pam_loginuid.so
    session required /nix/store/4m8ab1p9y6ig31wniimlvsl23i9sazvp-linux-pam-1.5.2/lib/security/pam_lastlog.so silent
    session optional /nix/store/8pbr7x6wh765mg43zs0p70gsaavmbbh7-systemd-253.3/lib/security/pam_systemd.so
    session optional /nix/store/21dqfghfa8b09ssvgja8l5bg7h5d9rzl-gnome-keyring-42.1/lib/security/pam_gnome_keyring.so auto_start
  '';

  security.pam.services.polkit-1.text = ''
    # Account management.
    account required pam_unix.so

    # Authentication management.
    auth    sufficient    /root/lib/pam/pam_fprintd_grosshack.so
    auth    sufficient    pam_unix.so try_first_pass nullok
    auth required pam_deny.so

    # Password management.
    password sufficient pam_unix.so nullok yescrypt

    # Session management.
    session required pam_env.so conffile=/etc/pam/environment readenv=0
    session required pam_unix.so
  '';

  networking.hostName = "wim";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  security.pam.services.gtklock = {};

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

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;
  };

  hardware.opengl.enable = true;

  xdg.portal.enable = true;
  services.flatpak.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.matt = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "adm" ];
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
    libsForQt5.qtstyleplugin-kvantum
    alacritty
    brightnessctl
    pulseaudio
    alsa-utils
    hyprland
    wget
    firefox
    tree
    mlocate
    gcc
    rsync
    tmux
    git
    git-lfs
    killall
    htop
    fzf
    libinput-gestures
    jq
    ripgrep
    hyprpaper
    python3
    rofi-wayland
    wev
    networkmanagerapplet
    nextcloud-client
    tutanota-desktop
    galaxy-buds-client
    gnome.gnome-keyring
    gnome.gnome-calculator
    swaynotificationcenter
    #swayosd
    (with import <nixpkgs> {}; callPackage ./cfg/swayosd.nix {})
    swayidle
    wl-clipboard
    cliphist
    polkit-kde-agent
    gtklock
    gtklock-playerctl-module
    gtklock-powerbar-module
    grim
    slurp
    swappy
    gnome.seahorse
    neovim
    fontfor
    qt5ct
    qt6Packages.qtstyleplugin-kvantum
    lxappearance
    gnome3.adwaita-icon-theme
    xorg.xcursorthemes
    imagemagick
    usbutils
    catppuccin-plymouth
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
      #fira-code
      #fira-code-symbols
      #mplus-outline-fonts.githubRelease
      #dina-font
      #proggyfonts
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

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.logind.lidSwitch = "lock";
  services.gnome.gnome-keyring.enable = true;
  
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
