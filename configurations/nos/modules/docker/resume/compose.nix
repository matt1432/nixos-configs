{
  configPath,
  TZ,
  ...
}: {pkgs, ...}: let
  rwPath = configPath + "/resume";
in {
  virtualisation.docker.compose."resume" = {
    networks.proxy_net = {external = true;};

    services = {
      "resume-app" = {
        image = pkgs.callPackage ./images/reactive-resume.nix pkgs;
        restart = "always";

        ports = ["3060:3000"];
        networks = ["proxy_net"];

        volumes = [
          "${rwPath}/data:/app/data"
        ];

        dependsOn = {
          postgres.condition = "service_healthy";
        };

        environment = {
          inherit TZ;

          # --- Server ---
          APP_URL = "https://resume.nelim.org";

          # --- Database (PostgreSQL) ---
          DATABASE_URL = "postgresql://postgres:postgres@postgres:5432/postgres";

          # --- Authentication ---
          AUTH_SECRET = "access_token_secret";
        };
      };

      "postgres" = {
        image = pkgs.callPackage ./images/postgres.nix pkgs;
        restart = "always";

        networks = ["proxy_net"];

        volumes = [
          "${rwPath}/db:/var/lib/postgresql"
        ];

        environment = {
          POSTGRES_DB = "postgres";
          POSTGRES_PASSWORD = "postgres";
          POSTGRES_USER = "postgres";
        };

        healthcheck = {
          interval = "10s";
          retries = 10;
          test = ["CMD-SHELL" "pg_isready -U postgres -d postgres"];
          timeout = "5s";
        };
      };
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
