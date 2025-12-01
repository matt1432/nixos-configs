self: {
  config,
  lib,
  pkgs,
  purePkgs ? pkgs,
  ...
}: let
  inherit (lib) attrValues makeBinPath mkIf remove;

  cfg = config.roles.base;
in {
  config = mkIf cfg.enable {
    nixpkgs.overlays =
      (map (i: self.inputs.${i}.overlays.default) [
        "grim-hyprland"
        "nixos-jellyfin"
        "nh"
        "nixd"
        "nurl"
      ])
      ++ [
        (final: prev: {
          firefox-devedition-unwrapped = prev.firefox-devedition-unwrapped.override {
            # Don't compile firefox on machines with cuda enabled
            # since it's not worth the > 3 hour build time
            inherit (purePkgs) onnxruntime;
          };
        })
      ];

    environment.systemPackages = remove null (attrValues {
      inherit
        (pkgs.selfPackages)
        pokemon-colorscripts
        repl
        ;

      nurl =
        if (cfg.user != "nixos" && cfg.user != "nix-on-droid")
        then
          pkgs.nurl.overrideAttrs {
            postInstall = ''
              wrapProgram $out/bin/nurl --prefix PATH : ${makeBinPath [
                (config.home-manager.users.${cfg.user}.programs.git.package or pkgs.gitMinimal)
                (config.nix.package or pkgs.nix)
                pkgs.mercurial
              ]}
              installManPage artifacts/nurl.1
              installShellCompletion artifacts/nurl.{bash,fish} --zsh artifacts/_nurl
            '';
          }
        else null;

      inherit
        (pkgs.nodePackages)
        undollar
        ;

      inherit (pkgs) alejandra just;

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
        nix-tree
        nix-update
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

      listDerivs = pkgs.writeShellApplication {
        name = "listDerivs";
        text = ''
          exec nix-store --query --requisites /run/current-system | cut -d- -f2- | sort -u
        '';
      };

      from = pkgs.writeShellApplication {
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
      };
    });
  };

  # For accurate stack trace
  _file = ./default.nix;
}
