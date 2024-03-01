{config, ...}: let
  inherit (config.sops) secrets;
  inherit (config.arion) rwDataDir;

  rwPath = rwDataDir + "/freshrss";
in {
  arion.projects."freshrss" = {
    "freshrss" = {
      image = ./images/freshrss.nix;
      restart = "always";

      ports = ["2800:80"];

      volumes = [
        "${rwPath}/data:/var/www/FreshRSS/data"
        "${rwPath}/data-extensions:/var/www/FreshRSS/extensions"
      ];

      env_file = [secrets.freshrss.path];

      environment = {
        TZ = "America/New_York";
        CRON_MIN = "'3,33'";
      };
    };

    "freshrss-db" = {
      image = ./images/postgres.nix;
      restart = "always";

      volumes = [
        "${rwPath}/db:/var/lib/postgresql/data"
      ];

      env_file = [secrets.freshrss.path];

      environment = {
        POSTGRES_DB = "\${DB_BASE:-freshrss}";
        POSTGRES_USER = "\${DB_USER:-freshrss}";
        POSTGRES_PASSWORD = "\${DB_PASSWORD:-freshrss}";
      };
    };

    "docker-hub-rss" = {
      image = ./images/docker-hub-rss.nix;
      restart = "always";
      ports = ["3007:3000"];
    };
  };
}
