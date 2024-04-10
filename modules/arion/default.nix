{
  arion,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    filterAttrs
    hasAttr
    mapAttrs
    mkEnableOption
    mkForce
    mkIf
    mkOption
    optionalAttrs
    types
    ;

  inherit (config.vars) mainUser;

  cfg = config.arion;
in {
  imports = [arion.nixosModules.arion];

  options.arion = {
    enable = mkEnableOption (lib.mdDoc "My custom arion config layer module");

    rwDataDir = mkOption {
      default = "/var/lib/arion";
      type = types.str;
      description = lib.mdDoc ''
        Directory to place persistent data in
      '';
    };

    projects = mkOption {
      default = {};
      description = lib.mdDoc ''
        Declarative specification of docker-compose in nix.
      '';
      type = types.attrs;
    };
  };

  config = mkIf cfg.enable {
    users.extraUsers.${mainUser}.extraGroups = ["docker"];

    virtualisation = {
      docker = {
        enable = true;
        storageDriver = "btrfs";
      };

      arion = {
        backend = "docker";

        projects =
          mapAttrs (n: v: {
            # https://docs.hercules-ci.com/arion/options
            settings = {
              enableDefaultNetwork = v.enableDefaultNetwork or true;

              networks =
                optionalAttrs (hasAttr "networks" v)
                v.networks;

              services =
                mapAttrs (n': v': {
                  # https://github.com/hercules-ci/arion/issues/169#issuecomment-1301370634
                  build.image = let
                    importImage = file: pkgs.callPackage file pkgs;
                  in
                    mkForce (importImage v'.image);

                  service =
                    (filterAttrs (attrName: _:
                      attrName != "image" && attrName != "extraOptions")
                    v')
                    # By default set the container_name to the attrset's name
                    // (optionalAttrs (! hasAttr "container_name" v') {
                      container_name = n';
                    });

                  out.service =
                    optionalAttrs
                    (hasAttr "extraOptions" v')
                    v'.extraOptions;
                })
                v;
            };
          })
          cfg.projects;
      };
    };

    # Script for updating the images of all images of a compose.nix file
    environment.systemPackages = with pkgs; [
      (writeShellApplication {
        name = "updateImages";

        runtimeInputs = [
          (writeShellApplication {
            name = "pullImage";
            runtimeInputs = [nix-prefetch-docker skopeo];
            text = ''
              FILE="$1"

              IMAGE=$(sed -n 's/.*imageName = "\([^"]*\).*/\1/p' "$FILE")
              TAG=$(sed -n 's/.*finalImageTag = "\([^"]*\).*/\1/p' "$FILE")
              CURRENT_DIGEST=$(sed -n 's/.*imageDigest = "\([^"]*\).*/\1/p' "$FILE")
              NEW_DIGEST=$(skopeo inspect "docker://$IMAGE:$TAG" | jq '.Digest' -r)

              echo "$IMAGE $TAG"

              if ! grep "Locked" "$FILE"; then
                  if [[ "$CURRENT_DIGEST" == "$NEW_DIGEST" ]]; then
                      echo "Already up-to-date"
                  else
                      PREFETCH=$(nix-prefetch-docker "$IMAGE" "$TAG")
                      echo -e "pkgs:\npkgs.dockerTools.pullImage $PREFETCH" > "$FILE"
                  fi
              fi
            '';
          })
        ];

        text = ''
          DIR=''${1:-"."}
          find "$DIR"/images -type f -exec pullImage {} \;
        '';
      })
    ];
  };
}
