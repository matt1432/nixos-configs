{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues;

  inherit (config.sops) secrets;
  inherit (config.khepri) rwDataDir;

  rwPath = rwDataDir + "/immich";

  UPLOAD_LOCATION = "${rwPath}/data";
  synologyPath = "/var/lib/synology-immich";
in {
  # NFS client setup
  services.rpcbind.enable = true;
  boot.supportedFilesystems = ["nfs"];

  environment.systemPackages = attrValues {
    inherit
      (pkgs)
      nfs-utils
      immich-go # for uploading google photos
      ;
  };

  systemd.mounts = let
    host = "10.0.0.117";
  in [
    {
      type = "nfs";
      mountConfig = {
        Options = "noatime";
      };
      what = "${host}:/volume1/Photo-Immich";
      where = synologyPath;
      wantedBy = ["multi-user.target"];
    }
  ];

  # Docker compose
  khepri.compositions."immich" = {
    networks.proxy_net = {external = true;};

    services = {
      "immich_server" = {
        image = import ./images/server.nix pkgs;

        restart = "always";

        environmentFiles = [
          ./env
          secrets.immich.path
        ];

        volumes = [
          # "${synologyPath}:/usr/src/app/upload:rw"
          "${UPLOAD_LOCATION}:/usr/src/app/upload:rw"
          "${synologyPath}:${synologyPath}:rw"
        ];
        ports = [
          "2283:2283"
        ];
        networks = ["proxy_net"];

        dependsOn = ["immich_redis" "immich_postgres"];

        environment.NODE_ENV = "production";
      };

      "immich_machine_learning" = {
        image = import ./images/machine-learning.nix pkgs;

        restart = "always";

        environmentFiles = [
          ./env
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

        environmentFiles = [
          ./env
          secrets.immich.path
        ];
        networks = ["proxy_net"];
        tmpfs = ["/data"];
      };

      "immich_postgres" = {
        image = import ./images/postgres.nix pkgs;

        restart = "always";

        environmentFiles = [
          ./env
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
