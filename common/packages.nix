{
  pkgs,
  self,
  ...
}: {
  environment.systemPackages =
    (with self.packages.${pkgs.system}; [
      pokemon-colorscripts
      repl
    ])
    ++ (with pkgs.nodePackages; [
      undollar
    ])
    ++ (with pkgs; [
      alejandra

      # Archiving
      zip
      unzip
      p7zip
      rar
      bzip2
      gzip
      gnutar
      xz

      # File management
      findutils
      diffutils
      utillinux
      which
      imagemagick

      # Networking
      dig.dnsutils
      openssh
      rsync
      wget
      gnupg

      # Misc CLI stuff
      killall
      nix-output-monitor
      progress
      tree
      gnugrep
      gnused

      # Expected Stuff
      hostname
      man
      perl
      tzdata
    ])
    ++ [
      # This could help as well: nix derivation show -r /run/current-system
      (pkgs.writeShellApplication {
        name = "listDerivs";
        text = ''
          nix-store --query --requisites /run/current-system | cut -d- -f2- | sort -u
        '';
      })

      (pkgs.writeShellApplication {
        name = "from";

        runtimeInputs = with pkgs; [
          coreutils
          which
        ];

        text = ''
          for var do
              realpath "$(which "$var")"
          done
        '';
      })
    ];
}
