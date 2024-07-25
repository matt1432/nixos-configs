{
  config,
  pkgs,
  ...
}: let
  inherit (config.khepri) rwDataDir;

  rwPath = rwDataDir + "/media/seerr";
in {
  khepri.compositions."seerr" = {
    networks.proxy_net = {external = true;};

    services."seerr" = {
      image = import ./images/jellyseerr.nix pkgs;
      restart = "always";

      environment = {
        LOG_LEVEL = "debug";
        TZ = "America/New_York";
      };

      volumes = [
        "${rwPath}/data:/app/config"
      ];

      extraHosts = ["lan.nelim.org:10.0.0.130"];
      networks = ["proxy_net"];
      ports = ["5055:5055"];
    };
  };
}
