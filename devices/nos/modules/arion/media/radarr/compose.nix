{config, ...}: let
  inherit (config.arion) rwDataDir;

  rwPath = rwDataDir + "/media/radarr";
in {
  arion.projects."radarr"."radarr" = {
    image = ./images/radarr.nix;
    restart = "always";

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

    extraOptions = {
      deploy.resources.limits.cpus = "0.5";
    };
  };
}
