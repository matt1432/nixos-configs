{
  configPath,
  mainUID,
  mainGID,
  ...
}: {
  config,
  pkgs,
  ...
}: let
  inherit (config.sops) secrets;

  rwPath = configPath + "/forgejo";
in {
  virtualisation.docker.compose."forgejo" = {
    networks.proxy_net = {external = true;};

    services = {
      "forgejo" = {
        image = pkgs.callPackage ./images/forgejo.nix pkgs;

        ports = [
          # Redirect WAN port 22 to this port
          "2222:22"
          "3000:3000"
        ];

        networks = ["proxy_net"];

        restart = "always";
        depends_on = ["forgejo-db"];

        env_file = [secrets.forgejo.path];
        environment = {
          APP_NAME = "Gitea";

          USER_UID = mainUID;
          USER_GID = mainGID;

          ROOT_URL = "https://git.nelim.org";
          SSH_DOMAIN = "git.nelim.org";
          SSH_PORT = "22";
          HTTP_PORT = "3000";
        };

        volumes = [
          "${rwPath}/data:/data"
          "/etc/timezone:/etc/timezone:ro"
          "/etc/localtime:/etc/localtime:ro"
        ];
      };

      "forgejo-db" = {
        image = pkgs.callPackage ./images/postgres.nix pkgs;

        restart = "always";

        env_file = [secrets.forgejo-db.path];
        networks = ["proxy_net"];

        volumes = ["${rwPath}/db:/var/lib/postgresql/data"];
      };

      "act_runner" = {
        image = pkgs.callPackage ./images/act_runner.nix pkgs;

        privileged = true;
        user = "root:root";
        networks = ["proxy_net"];

        restart = "always";
        depends_on = ["forgejo"];

        environment = {
          GITEA_RUNNER_NAME = "DinD";
          GITEA_INSTANCE_URL = "https://git.nelim.org";
          GITEA_RUNNER_REGISTRATION_TOKEN_FILE = secrets.forgejo-runner.path;
        };

        volumes = [
          "${rwPath}/act:/data"
          "${secrets.forgejo-runner.path}:${secrets.forgejo-runner.path}"
        ];
        extra_hosts = ["git.nelim.org:10.0.0.130"];
      };
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
