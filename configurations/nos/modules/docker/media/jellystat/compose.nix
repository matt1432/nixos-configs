{
  configPath,
  TZ,
  ...
}: {
  config,
  pkgs,
  ...
}: let
  inherit (config.sops) secrets;

  rwPath = configPath + "/jellystat";
in {
  virtualisation.docker.compose."jellystat" = {
    networks.proxy_net = {external = true;};

    services = {
      "jellystat" = {
        image = pkgs.callPackage ./images/jellystat.nix pkgs;
        restart = "always";

        env_file = [secrets.jellystat.path];
        environment = {
          JS_BASE_URL = "jellystat";

          POSTGRES_IP = "jellystat-db";
          POSTGRES_PORT = 5432;
          inherit TZ;
        };

        ports = ["3070:3000"];
        networks = ["proxy_net"];

        volumes = ["${rwPath}/data:/app/backend/backup-data"];

        depends_on = ["jellystat-db"];
      };

      "jellystat-db" = {
        image = pkgs.callPackage ./images/postgres.nix pkgs;
        restart = "always";

        env_file = [secrets.jellystat.path];
        networks = ["proxy_net"];

        volumes = ["${rwPath}/db:/var/lib/postgresql/data"];
      };
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
