{
  config,
  pkgs,
  ...
}: let
  inherit (config.sops) secrets;
  inherit (config.khepri) rwDataDir;

  rwPath = rwDataDir + "/immich";

  UPLOAD_LOCATION = "${rwPath}/data";
in {
  khepri.compositions."immich" = {
    networks.proxy_net = {external = true;};

    services = {
      "immich_server" = {
        image = import ./images/server.nix pkgs;
        environmentFiles = [
          "${./env}"
          secrets.immich.path
        ];

        volumes = [
          "${UPLOAD_LOCATION}:/usr/src/app/upload:rw"
        ];
        ports = [
          "2283:2283"
        ];
        networks = ["proxy_net"];

        dependsOn = ["immich_redis" "immich_postgres"];
        restart = "always";

        environment.NODE_ENV = "production";
      };

      "immich_machine_learning" = {
        image = import ./images/machine-learning.nix pkgs;
        restart = "always";
        environmentFiles = [
          "${./env}"
          secrets.immich.path
        ];
        networks = ["proxy_net"];

        volumes = [
          "${rwPath}/cache:/cache"
        ];
      };

      "immich_redis" = {
        image = import ./images/redis.nix pkgs;
        restart = "always";
        tmpfs = ["/data"];
        environmentFiles = [
          "${./env}"
          secrets.immich.path
        ];
        networks = ["proxy_net"];
      };

      "immich_postgres" = {
        image = import ./images/postgres.nix pkgs;
        restart = "always";
        environmentFiles = [
          "${./env}"
          secrets.immich.path
        ];
        networks = ["proxy_net"];

        volumes = [
          "${rwPath}/db:/var/lib/postgresql/data"
        ];

        environment = {
          POSTGRES_PASSWORD = "\${DB_PASSWORD}";
          POSTGRES_USER = "\${DB_USERNAME}";
          POSTGRES_DB = "\${DB_DATABASE_NAME}";
        };
      };
    };
  };
}
