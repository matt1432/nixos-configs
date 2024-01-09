{
  arion,
  config,
  lib,
  pkgs,
  ...
} @ inputs:
with lib;
with builtins; let
  inherit (config.vars) mainUser;
  configPath = "/var/lib/arion";
in {
  imports = [arion.nixosModules.arion];

  users.extraUsers.${mainUser}.extraGroups = ["docker"];


  services.borgbackup.configs.arion = {
    paths = [configPath];
    exclude = ["**/lineageos*"];
  };

  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "btrfs";
    };

    arion = {
      backend = "docker";

      projects = let
        composeFiles =
          filter (n: hasSuffix "compose.nix" (toString n))
          (filesystem.listFilesRecursive ./.);

        projects = filterAttrs (n: v: v.enabled or true) (listToAttrs (map (p: {
            name = elemAt (match ".*\/(.*)\/compose\.nix" (toString p)) 0;

            value = import p (inputs
              // {
                importImage = file: pkgs.callPackage file pkgs;
                rwPath =
                  configPath
                  + "/"
                  + elemAt (match "[^-]*-(.*)" "${dirOf p}") 0;
              });
          })
          composeFiles));
      in
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
                build.image =
                  optionalAttrs (hasAttr "hostImage" v')
                  (mkForce v'.hostImage);

                image =
                  optionalAttrs (hasAttr "customImage" v')
                  v'.customImage;

                service =
                  filterAttrs
                  (n: v: n != "customImage" && n != "hostImage")
                  v';
              })
              v.services;
          };
        })
        projects;
    };
  };
}
