{
  config,
  pkgs,
  ...
}: let
  inherit (config.khepri) rwDataDir;

  rwPath = rwDataDir + "/media/prowlarr";
in {
  khepri.compositions."prowlarr" = {
    networks.proxy_net = {external = true;};

    services = {
      "prowlarr" = {
        image = import ./images/prowlarr.nix pkgs;
        restart = "always";

        environment = {
          PUID = "1000";
          PGID = "1000";
          TZ = "America/New_York";
        };

        volumes = ["${rwPath}/data:/config"];

        ports = ["9696:9696"];
        networks = ["proxy_net"];
      };

      "flaresolverr" = {
        image = import ./images/flaresolverr.nix pkgs;
        restart = "always";

        environment = {
          LOG_LEVEL = "info";
          LOG_HTML = "false";
          CAPTCHA_SOLVER = "none";
          TZ = "America/New_York";

          # https://github.com/FlareSolverr/FlareSolverr/pull/1300#issuecomment-2379596654
          DRIVER = "nodriver";
        };

        ports = ["8191:8191"];

        dependsOn = ["prowlarr"];
        networks = ["proxy_net"];
      };
    };
  };
}
