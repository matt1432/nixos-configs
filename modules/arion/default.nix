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
    enable = mkEnableOption "My custom arion config layer module";

    rwDataDir = mkOption {
      default = "/var/lib/arion";
      type = types.str;
      description = ''
        Directory to place persistent data in
      '';
    };

    projects = mkOption {
      default = {};
      description = ''
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
      (callPackage ./updateImage.nix {})
    ];
  };
}
