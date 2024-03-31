{pkgs, ...}: {
  vars = {
    mainUser = "nix-on-droid";
    hostName = "localhost";
    neovimIde = false;
  };

  environment.variables.FLAKE = "/data/data/com.termux.nix/files/home/.nix";

  terminal.font = "${(pkgs.nerdfonts.override {
    fonts = [
      "JetBrainsMono"
    ];
  })}/share/fonts/truetype/NerdFonts/JetBrainsMonoNerdFontMono-Regular.ttf";

  environment.packages = with pkgs; [
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
    openssh
    perl
    alejandra
  ];

  environment.etcBackupExtension = ".bak";
  environment.motd = null;
  home-manager.backupFileExtension = "hm-bak";

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # No touchy
  system.stateVersion = "23.05";
}
