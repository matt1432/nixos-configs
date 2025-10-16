{configPath, ...}: {pkgs, ...}: let
  rwPath = configPath + "/resume";
in {
  virtualisation.docker.compose."resume" = {
    networks.proxy_net = {external = true;};

    services = {
      "app" = {
        image = pkgs.callPackage ./images/reactive-resume.nix pkgs;
        restart = "always";

        ports = ["3060:3060"];
        networks = ["proxy_net"];

        dependsOn = ["postgres" "minio" "chrome"];

        environment = {
          # -- Environment Variables --
          PORT = "3060";
          NODE_ENV = "production";

          # -- URLs --
          PUBLIC_URL = "http://app:3060";
          STORAGE_URL = "https://resume-storage.nelim.org/default";

          # -- Printer (Chrome) --
          CHROME_TOKEN = "chrome_token";
          CHROME_URL = "ws://chrome:3000";

          # -- Database (Postgres) --
          DATABASE_URL = "postgresql://postgres:postgres@postgres:5432/postgres";

          # -- Auth --
          ACCESS_TOKEN_SECRET = "access_token_secret";
          REFRESH_TOKEN_SECRET = "refresh_token_secret";

          # -- Emails --
          MAIL_FROM = "noreply@localhost";
          # SMTP_URL = "smtp://user:pass@smtp:587"; # Optional

          # -- Storage (Minio) --
          STORAGE_ENDPOINT = "minio";
          STORAGE_PORT = "9000";
          STORAGE_REGION = "us-east-1";
          STORAGE_BUCKET = "default";
          STORAGE_ACCESS_KEY = "minioadmin";
          STORAGE_SECRET_KEY = "minioadmin";
          STORAGE_USE_SSL = "false";
          STORAGE_SKIP_BUCKET_CHECK = "false";
        };
      };

      "chrome" = {
        image = pkgs.callPackage ./images/chrome.nix pkgs;
        restart = "always";

        networks = ["proxy_net"];

        environment = {
          TIMEOUT = "50000";
          CONCURRENT = "10";
          TOKEN = "chrome_token";
          HEALTH = "true";
          EXIT_ON_HEALTH_FAILURE = "true";
        };
      };

      "minio" = {
        image = pkgs.callPackage ./images/minio.nix pkgs;
        restart = "always";

        command = "server /data";

        ports = ["9000:9000"];
        networks = ["proxy_net"];

        volumes = ["${rwPath}/minio:/data"];

        environment = {
          MINIO_ROOT_PASSWORD = "minioadmin";
          MINIO_ROOT_USER = "minioadmin";
        };
      };

      "postgres" = {
        image = pkgs.callPackage ./images/postgres.nix pkgs;
        restart = "always";

        networks = ["proxy_net"];

        volumes = [
          "${rwPath}/db:/var/lib/postgresql/data"
        ];

        environment = {
          POSTGRES_DB = "postgres";
          POSTGRES_PASSWORD = "postgres";
          POSTGRES_USER = "postgres";
        };

        healthcheck = {
          interval = "10s";
          retries = 5;
          test = ["CMD-SHELL" "pg_isready -U postgres -d postgres"];
          timeout = "5s";
        };
      };
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
