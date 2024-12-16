{
  config,
  pkgs,
  ...
}: let
  inherit (config.khepri) rwDataDir;

  rwPath = rwDataDir + "/media/bazarr";
in {
  khepri.compositions."bazarr" = {
    networks.proxy_net = {external = true;};

    services."bazarr" = {
      image = import ./images/bazarr.nix pkgs;
      restart = "always";

      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/New_York";
      };

      ports = [
        "6767:6767"
      ];

      volumes = [
        "${rwPath}/data:/config"
        "/data:/data"
      ];

      cpus = 2;
      networks = ["proxy_net"];
    };
  };
}
