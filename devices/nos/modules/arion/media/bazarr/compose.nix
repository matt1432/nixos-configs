{config, ...}: let
  inherit (config.arion) rwDataDir;

  rwPath = rwDataDir + "/media/bazarr";
in {
  arion.projects."bazarr" = {
    "bazarr" = {
      image = ./images/bazarr.nix;
      restart = "always";

      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/New_York";
      };

      extra_hosts = ["lan.nelim.org=10.0.0.130"];
      ports = [
        "6767:6767"
      ];

      volumes = [
        "${rwPath}/data:/config"
        "/data:/data"
      ];

      extraOptions = {
        deploy.resources.limits.cpus = "0.5";
      };
    };

    "bazarr-fr" = {
      image = ./images/bazarr.nix;
      restart = "always";

      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/New_York";
      };

      extra_hosts = ["lan.nelim.org=10.0.0.130"];
      ports = [
        "6766:6767"
      ];

      volumes = [
        "${rwPath}/data-fr:/config"
        "/data:/data"
      ];

      extraOptions = {
        deploy.resources.limits.cpus = "0.5";
      };
    };
  };
}
