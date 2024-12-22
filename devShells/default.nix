{
  pkgs,
  self,
  ...
}: let
  inherit (builtins) attrValues;

  langsShells = import ./langs.nix {inherit pkgs self;};

  bumpNpmDeps = pkgs.writeShellApplication {
    name = "bumpNpmDeps";
    runtimeInputs = attrValues {
      inherit
        (pkgs)
        prefetch-npm-deps
        nodejs_latest
        ;
    };
    text = ''
      # this command might fail but still updates the main lockfile
      npm i --package-lock-only || true
      prefetch-npm-deps ./package-lock.json
    '';
  };
in
  {
    default = pkgs.mkShell {
      packages = [
        (pkgs.writeShellApplication {
          name = "mkIso";

          runtimeInputs = attrValues {
            inherit
              (pkgs)
              nix-output-monitor
              ;
          };

          text = ''
            isoConfig="nixosConfigurations.live-image.config.system.build.isoImage"
            nom build "$FLAKE#$isoConfig"
          '';
        })

        (pkgs.writeShellApplication {
          name = "fixUidChange";

          runtimeInputs = attrValues {
            inherit
              (pkgs)
              findutils
              gnused
              ;
          };

          text = ''
            GROUP="$1"
            OLD_GID="$2"
            NEW_GID="$3"

            # Remove generated group entry
            sudo sed -i -e "/^$GROUP:/d" /etc/group

            # Change GID on existing files
            sudo find / -gid "$OLD_GID" -exec chgrp "$NEW_GID" {} +
          '';
        })
      ];
    };

    netdaemon = pkgs.mkShell {
      packages = attrValues {
        inherit
          (pkgs.dotnetCorePackages)
          sdk_9_0
          ;
      };
    };

    node = pkgs.mkShell {
      packages = attrValues {
        inherit
          (pkgs)
          nodejs_latest
          typescript
          ;

        inherit
          bumpNpmDeps
          ;
      };
    };

    subtitles-dev = pkgs.mkShell {
      packages = attrValues {
        inherit
          (pkgs)
          nodejs_latest
          typescript
          ffmpeg-full
          ;

        inherit
          (pkgs.nodePackages)
          ts-node
          ;

        inherit
          bumpNpmDeps
          ;
      };
    };
  }
  // langsShells
