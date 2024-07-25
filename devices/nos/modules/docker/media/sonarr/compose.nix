{
  config,
  pkgs,
  ...
}: let
  inherit (config.khepri) rwDataDir;

  rwPath = rwDataDir + "/media/sonarr";
in {
  khepri.compositions."sonarr" = {
    networks.proxy_net = {external = true;};

    services."sonarr" = {
      image = import ./images/sonarr.nix pkgs;
      restart = "always";

      extraHosts = ["lan.nelim.org:10.0.0.130"];
      ports = ["8989:8989"];

      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/New_York";
      };

      volumes = [
        "${rwPath}/data:/config"
        "/data:/data"
      ];

      cpus = 0.5;
      networks = ["proxy_net"];
    };
  };
}
