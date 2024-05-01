{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.sops) secrets;
  inherit (config.arion) rwDataDir;
  inherit (lib) concatStrings;

  mainContainerName = "app-server";
  rwPath = rwDataDir + "/nextcloud";
in {
  arion.projects."nextcloud" = {
    "${mainContainerName}" = {
      image = ./images/nextcloud.nix;
      restart = "always";

      expose = [
        "80"
        "9000"
      ];

      volumes = [
        "${rwPath}/data:/var/www/html"
        "/data/docs:/var/www/drive"
      ];

      env_file = [secrets.nextcloud.path];

      environment = {
        POSTGRES_DB = "nextcloud";
        POSTGRES_HOST = "nextcloud-db";
        REDIS_HOST = "nextcloud-cache";
        REDIS_HOST_PASSWORD = "password";
        NEXTCLOUD_INIT_HTACCESS = "true";
      };
    };

    "onlyoffice-document-server" = {
      image = ./images/onlyoffice.nix;
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
      image = ./images/nginx.nix;
      restart = "always";
      ports = ["8042:80"];
      volumes = [
        "${./nginx.conf}:/etc/nginx/nginx.conf"
        "${rwPath}/data:/var/www/html"
      ];
    };

    "nextcloud-db" = {
      image = ./images/postgres.nix;
      restart = "always";
      env_file = [secrets.nextcloud.path];
      volumes = [
        "${rwPath}/database:/var/lib/postgresql/data"
        "/etc/localtime:/etc/localtime:ro"
      ];
    };

    "nextcloud-cache" = {
      image = ./images/redis.nix;
      restart = "always";
      #mem_limit = "2048m";
      #mem_reservation = "512m";
      env_file = [secrets.nextcloud.path];
      command = ''/bin/sh -c "redis-server --requirepass $$REDIS_HOST_PASSWORD"'';
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
    requires = ["arion-nextcloud.service"];
    after = ["arion-nextcloud.service"];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.docker}/bin/docker exec -u www-data ${mainContainerName} php -f /var/www/html/cron.php";
    };
  };
}
