{
  nurl,
  nix-melt,
  pkgs,
  ...
}: {
  terminal.font = "${(pkgs.nerdfonts.override {
    fonts = [
      "JetBrainsMono"
    ];
  })}/share/fonts/truetype/NerdFonts/JetBrainsMonoNerdFontMono-Regular.ttf";

  # Simply install just the packages
  environment.packages = with pkgs; [
    # User-facing stuff that you really really want to have
    vim # or some other editor, e.g. nano or neovim

    # Some common stuff that people expect to have
    diffutils
    findutils
    utillinux
    tzdata
    hostname
    man
    gnugrep
    ripgrep
    gnupg
    gnused
    gnutar
    bzip2
    gzip
    xz
    zip
    unzip
    git
    comma
    neofetch
    progress
    wget
    tree
    mosh
    openssh
    imagemagick
    nodePackages.undollar
    perl
    alejandra

    nurl.packages.aarch64-linux.default
    nix-melt.packages.aarch64-linux.default
  ];

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";
  environment.motd = null;

  # Read the changelog before changing this value
  system.stateVersion = "23.05";

  # Set your time zone
  #time.timeZone = "Europe/Berlin";

  imports = [
  ];

  home-manager = {
    config = {
      config,
      lib,
      pkgs,
      ...
    }: {
      imports = [
        ./home/bash
        ./home/git.nix
        ./home/neovim
        ./home/tmux.nix
      ];
      home.stateVersion = "23.05";
    };
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
  };
}
