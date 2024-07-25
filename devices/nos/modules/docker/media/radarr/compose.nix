{
  config,
  pkgs,
  ...
}: let
  inherit (config.khepri) rwDataDir;

  rwPath = rwDataDir + "/media/radarr";
in {
  khepri.compositions."radarr" = {
    networks.proxy_net = {external = true;};

    services."radarr" = {
      image = import ./images/radarr.nix pkgs;
      restart = "always";

      extraHosts = ["lan.nelim.org:10.0.0.130"];
      ports = ["7878:7878"];

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
