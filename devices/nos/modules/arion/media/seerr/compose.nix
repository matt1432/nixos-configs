{config, ...}: let
  inherit (config.arion) rwDataDir;

  rwPath = rwDataDir + "/media/seerr";
in {
  arion.projects."seerr"."seerr" = {
    image = ./images/jellyseerr.nix;
    restart = "always";

    environment = {
      LOG_LEVEL = "debug";
      TZ = "America/New_York";
    };

    volumes = [
      "${rwPath}/data:/app/config"
    ];

    ports = ["5055:5055"];
  };
}
