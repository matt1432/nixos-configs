{config, ...}: let
  inherit (config.sops) secrets;
  inherit (config.arion) rwDataDir;

  rwPath = rwDataDir + "/immich";

  UPLOAD_LOCATION = "${rwPath}/data";
in {
  arion.projects."immich" = {
    "immich_server" = {
      image = ./images/server.nix;
      command = ["start.sh" "immich"];
      env_file = [
        "${./.env}"
        secrets.immich.path
      ];

      volumes = [
        "${UPLOAD_LOCATION}:/usr/src/app/upload:rw"
      ];
      ports = [
        "2283:3001"
      ];

      depends_on = ["immich_redis" "immich_postgres"];
      restart = "always";

      environment.NODE_ENV = "production";
    };

    "immich_microservices" = {
      image = ./images/server.nix;
      command = ["start.sh" "microservices"];
      env_file = [
        "${./.env}"
        secrets.immich.path
      ];

      volumes = [
        "${UPLOAD_LOCATION}:/usr/src/app/upload:rw"
      ];

      depends_on = ["immich_redis" "immich_postgres"];
      restart = "always";
    };

    "immich_machine_learning" = {
      image = ./images/machine-learning.nix;
      restart = "always";
      env_file = [
        "${./.env}"
        secrets.immich.path
      ];

      volumes = [
        "${rwPath}/cache:/cache"
      ];
    };

    "immich_redis" = {
      image = ./images/redis.nix;
      restart = "always";
      tmpfs = ["/data"];
      env_file = [
        "${./.env}"
        secrets.immich.path
      ];
    };

    "immich_postgres" = {
      image = ./images/postgres.nix;
      restart = "always";
      env_file = [
        "${./.env}"
        secrets.immich.path
      ];

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
}
