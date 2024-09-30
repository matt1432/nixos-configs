inputs @ {
  pkgs,
  self,
  ...
}: {
  nixpkgs.overlays =
    (map (i: inputs.${i}.overlays.default) [
      "discord-overlay"
      "grim-hyprland"
      "nixpkgs-wayland"
    ])
    ++ (builtins.attrValues {
      inherit
        (self.overlays)
        xdg-desktop-portal-kde
        ;
    });

  environment.systemPackages =
    (builtins.attrValues {
      inherit
        (self.packages.${pkgs.system})
        pokemon-colorscripts
        repl
        ;

      inherit
        (pkgs.nodePackages)
        undollar
        ;

      inherit (pkgs) alejandra;

      # Archiving
      inherit
        (pkgs)
        zip
        unzip
        p7zip
        bzip2
        gzip
        gnutar
        xz
        ;

      # File management
      inherit
        (pkgs)
        findutils
        diffutils
        utillinux
        which
        imagemagick
        ;

      # Networking
      inherit (pkgs.dig) dnsutils;
      inherit
        (pkgs)
        arp-scan
        openssh
        rsync
        wget
        gnupg
        ;

      # Misc CLI stuff
      inherit
        (pkgs)
        killall
        nix-output-monitor
        progress
        tree
        gnugrep
        gnused
        ;

      # Expected Stuff
      inherit
        (pkgs)
        hostname
        man
        perl
        tzdata
        ;
    })
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

        runtimeInputs = builtins.attrValues {
          inherit
            (pkgs)
            coreutils
            which
            ;
        };

        text = ''
          for var do
              realpath "$(which "$var")"
          done
        '';
      })
    ];
}
