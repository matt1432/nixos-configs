{
  config,
  pkgs,
  ...
}: let
  inherit (config.khepri) rwDataDir;

  rwPath = rwDataDir + "/media/sabnzbd";
in {
  khepri.compositions."sabnzbd" = {
    networks.proxy_net = {external = true;};

    services."sabnzbd" = {
      image = import ./images/sabnzbd.nix pkgs;
      restart = "always";

      extraHosts = ["lan.nelim.org:10.0.0.130"];
      ports = ["8382:8082"];

      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/New_York";
      };

      volumes = [
        "${rwPath}/data:/config"
        "/data:/data"
      ];

      cpus = 2;
      networks = ["proxy_net"];
    };
  };
}
