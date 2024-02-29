{config, ...}: let
  inherit (config.arion) rwDataDir;

  rwPath = rwDataDir + "/media/prowlarr";
in {
  arion.projects."prowlarr" = {
    "prowlarr" = {
      image = ./images/prowlarr.nix;
      restart = "always";

      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/New_York";
      };

      volumes = ["${rwPath}/data:/config"];
      ports = ["9696:9696"];
    };

    "flaresolverr" = {
      image = ./images/flaresolverr.nix;
      restart = "always";

      environment = {
        LOG_LEVEL = "info";
        LOG_HTML = "false";
        CAPTCHA_SOLVER = "none";
        TZ = "America/New_York";
      };

      ports = ["8191:8191"];

      depends_on = ["prowlarr"];
    };
  };
}
