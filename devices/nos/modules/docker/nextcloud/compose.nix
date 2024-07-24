{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) concatStrings;

  inherit (config.sops) secrets;
  inherit (config.khepri) rwDataDir;

  mainContainerName = "app-server";
  rwPath = rwDataDir + "/nextcloud";
in {
  khepri.compositions."nextcloud".services = {
    "${mainContainerName}" = {
      image = import ./images/nextcloud.nix pkgs;
      restart = "always";

      expose = [
        "80"
        "9000"
      ];

      volumes = [
        "${rwPath}/data:/var/www/html"
        "/data/docs:/var/www/drive"
      ];

      environmentFiles = [secrets.nextcloud.path];

      environment = {
        POSTGRES_DB = "nextcloud";
        POSTGRES_HOST = "nextcloud-db";
        REDIS_HOST = "nextcloud-cache";
        REDIS_HOST_PASSWORD = "password";
        NEXTCLOUD_INIT_HTACCESS = "true";
      };
    };

    "onlyoffice-document-server" = {
      image = import ./images/onlyoffice.nix pkgs;
      restart = "always";

      environment.JWT_ENABLED = "false";

      ports = ["8055:80"];
      expose = [
        "80"
        "443"
      ];

      volumes = ["${rwPath}/data-onlyoffice:/var/log/onlyoffice"];
      tmpfs = [
        "/var/www/onlyoffice/Data"
        "/var/lib/postgresql"
        "/usr/share/fonts/truetype/custom"
        "/var/lib/rabbitmq"
        "/var/lib/redis"
        "/var/lib/onlyoffice"
      ];

      entrypoint = ''bash -c "${let
          filePath = "/var/www/onlyoffice/documentserver/web-apps/apps/*/mobile/dist/js/app.js";
          func = "isSupportEditFeature=function()";
        in
          concatStrings [
            # Fix proxies
            ''sed -i 's/"allowPrivateIPAddress": false,/"allowPrivateIPAddress": true,/' /etc/onlyoffice/documentserver/default.json''
            ''sed -i 's/"allowMetaIPAddress": false/"allowMetaIPAddress": true/' /etc/onlyoffice/documentserver/default.json''

            # Fix mobile editing
            "sed -i 's/${func}{return!1}/${func}{return 1}/g' ${filePath};"
            "/app/ds/run-document-server.sh;"
            "apt update;"
            "apt install imagemagick -y;"
          ]}"'';
    };

    "nginx-server" = {
      image = import ./images/nginx.nix pkgs;
      restart = "always";
      ports = ["8042:80"];
      volumes = [
        "${./nginx.conf}:/etc/nginx/nginx.conf"
        "${rwPath}/data:/var/www/html"
      ];
    };

    "nextcloud-db" = {
      image = import ./images/postgres.nix pkgs;
      restart = "always";
      environmentFiles = [secrets.nextcloud.path];
      volumes = [
        "${rwPath}/database:/var/lib/postgresql/data"
        "/etc/localtime:/etc/localtime:ro"
      ];
    };

    "nextcloud-cache" = {
      image = import ./images/redis.nix pkgs;
      restart = "always";
      #mem_limit = "2048m";
      #mem_reservation = "512m";
      environmentFiles = [secrets.nextcloud.path];
      cmd = [''/bin/sh -c "redis-server --requirepass $$REDIS_HOST_PASSWORD"''];
      tmpfs = [
        "/data"
      ];
    };
  };

  # Cron job
  systemd.timers.nextcloud-cron = {
    description = "Timer For Nextcloud Cron";
    wantedBy = ["timers.target"];

    timerConfig.OnBootSec = "5m";
    timerConfig.OnUnitActiveSec = "5m";
  };
  systemd.services.nextcloud-cron = {
    description = "Nextcloud Cron";
    requires = ["docker-nextcloud_app-server.service"];
    after = ["docker-nextcloud_app-server.service"];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.docker}/bin/docker exec -u www-data ${mainContainerName} php -f /var/www/html/cron.php";
    };
  };
}
