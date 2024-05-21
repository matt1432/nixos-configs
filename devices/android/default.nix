{
  config,
  lib,
  pkgs,
  ...
}: {
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

  environment.packages =
    (with pkgs; [
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
      which
      alejandra
    ])
    ++ [
      (pkgs.writeShellApplication {
        name = "switch";
        runtimeInputs = with pkgs; [
          nix-output-monitor
        ];
        text = ''
          exec nix-on-droid ${lib.concatStringsSep " " [
            "switch"
            "--flake ${config.environment.variables.FLAKE}"
            "--builders ssh-ng://matt@100.64.0.7"
            ''"$@"''
            "|&"
            "nom"
          ]}
        '';
      })
    ];

  environment.etcBackupExtension = ".bak";
  environment.motd = null;
  home-manager.backupFileExtension = "hm-bak";

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # No touchy
  system.stateVersion = "23.05";
}
