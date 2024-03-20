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
      extra_hosts = ["lan.nelim.org=10.0.0.130"];
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

      extra_hosts = ["lan.nelim.org=10.0.0.130"];
      ports = ["8191:8191"];

      depends_on = ["prowlarr"];
    };
  };
}
