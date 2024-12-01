self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues mkIf;

  cfg = config.roles.base;
in {
  config = mkIf (cfg.enable) {
    nixpkgs.overlays =
      (map (i: self.inputs.${i}.overlays.default) [
        "discord-overlay"
        "grim-hyprland"
        "nixpkgs-wayland"
      ])
      ++ (attrValues {
        inherit
          (self.overlays)
          xdg-desktop-portal-kde
          ;
      });

    # FIXME: Omnisharp uses dotnet6
    nixpkgs.config.permittedInsecurePackages = [
      "dotnet-core-combined"
      "dotnet-sdk-6.0.428"
      "dotnet-sdk-wrapped-6.0.428"
    ];

    environment.systemPackages =
      (attrValues {
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
          util-linux
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
          hydra-check
          killall
          nix-output-monitor
          nix-melt
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
            exec nix-store --query --requisites /run/current-system | cut -d- -f2- | sort -u
          '';
        })

        (pkgs.writeShellApplication {
          name = "from";

          runtimeInputs = attrValues {
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
  };

  # For accurate stack trace
  _file = ./default.nix;
}
