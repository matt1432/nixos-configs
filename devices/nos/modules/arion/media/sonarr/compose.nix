{config, ...}: let
  inherit (config.arion) rwDataDir;

  rwPath = rwDataDir + "/media/sonarr";
in {
  arion.projects."sonarr"."sonarr" = {
    image = ./images/sonarr.nix;
    restart = "always";

    extra_hosts = ["lan.nelim.org=10.0.0.130"];
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

    extraOptions = {
      deploy.resources.limits.cpus = "0.5";
    };
  };
}
