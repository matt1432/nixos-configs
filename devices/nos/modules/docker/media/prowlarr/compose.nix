{
  config,
  pkgs,
  ...
}: let
  inherit (config.khepri) rwDataDir;

  rwPath = rwDataDir + "/media/prowlarr";
in {
  khepri.compositions."prowlarr".services = {
    "prowlarr" = {
      image = import ./images/prowlarr.nix pkgs;
      restart = "always";

      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/New_York";
      };

      volumes = ["${rwPath}/data:/config"];
      extraHosts = ["lan.nelim.org=10.0.0.130"];
      ports = ["9696:9696"];
    };

    "flaresolverr" = {
      image = import ./images/flaresolverr.nix pkgs;
      restart = "always";

      environment = {
        LOG_LEVEL = "info";
        LOG_HTML = "false";
        CAPTCHA_SOLVER = "none";
        TZ = "America/New_York";
      };

      extraHosts = ["lan.nelim.org=10.0.0.130"];
      ports = ["8191:8191"];

      dependsOn = ["prowlarr"];
    };
  };
}
