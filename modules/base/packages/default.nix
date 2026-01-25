self: {
  config,
  lib,
  pkgs,
  purePkgs ? pkgs,
  ...
}: let
  inherit (lib) attrValues mkIf remove;

  cfg = config.roles.base;
in {
  config = mkIf cfg.enable {
    nixpkgs.overlays =
      (map (i: self.inputs.${i}.overlays.default) [
        "grim-hyprland"
        "nixos-jellyfin"
        "nh"
        "nixd"
        "neovim-nightly"
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

      nurl = pkgs.nurl.override {
        gitMinimal = config.home-manager.users.${cfg.user}.programs.git.package or pkgs.gitMinimal;
      };

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

      yaml2nix = pkgs.writeShellApplication {
        name = "yaml2nix";
        runtimeInputs = with pkgs; [yj];
        text = ''
          input="$(yj < "$1")"
          output="''${2:-""}"

          nixCode="$(nix eval --expr "builtins.fromJSON '''$input'''" --impure | alejandra -q | sed 's/ = null;/ = {};/g')"

          if [[ "$output" != "" ]]; then
              echo "$nixCode" > "$output"
          else
              echo "$nixCode"
          fi
        '';
      };

      nix2yaml = pkgs.writeShellApplication {
        name = "nix2yaml";
        runtimeInputs = with pkgs; [remarshal];
        text = ''
          input="$1"
          output="''${2:-""}"

          yamlCode="$(nix eval --json --file "$input" | remarshal --if json --of yaml)"

          if [[ "$output" != "" ]]; then
              echo "$yamlCode" > "$output"
          else
              echo "$yamlCode"
          fi
        '';
      };
    });
  };

  # For accurate stack trace
  _file = ./default.nix;
}
