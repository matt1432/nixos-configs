{
  arion,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  user = config.vars.user;
in {
  imports = [arion.nixosModules.arion];

  users.extraUsers.${user}.extraGroups = ["podman"];
  home-manager.users.${user}.programs.bash.shellAliases = {
    podman = "sudo podman ";
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    arion = {
      backend = "podman-socket";

      projects = let
        composeFiles =
          filter (n: hasSuffix "compose.nix" (toString n))
          (filesystem.listFilesRecursive ./.);

        projects = listToAttrs (map (p: {
            name = elemAt (match ".*\/(.*)\/compose\.nix" (toString p)) 0;
            value = import p;
          })
          composeFiles);
      in
        mapAttrs (n: v: {
          # https://docs.hercules-ci.com/arion/options
          settings = {
            enableDefaultNetwork = v.enableDefaultNetwork or true;
            networks = optionalAttrs (hasAttr "networks" v) v.networks;

            services = mapAttrs (n': v': {
              image = optionalAttrs (hasAttr "customImage" v') v'.customImage;
              service = filterAttrs (n: v: n != "customImage") v';
            }) v.services;
          };
        })
        projects;
    };
  };
}
