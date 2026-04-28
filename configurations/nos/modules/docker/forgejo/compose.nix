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

      "docker_dind" = {
        image = pkgs.callPackage ./images/docker_dind.nix pkgs;

        command = ["dockerd" "-H" "tcp://0.0.0.0:2375" "--tls=false"];

        privileged = "true";

        restart = "always";

        extraHosts = ["git.nelim.org:10.0.0.130"];
        networks = ["proxy_net"];
      };

      "runner" = {
        image = pkgs.callPackage ./images/runner.nix pkgs;

        user = "${mainUID}:${mainGID}";
        command = "forgejo-runner daemon --config runner-config.yml";

        restart = "always";
        depends_on = ["docker_dind" "forgejo"];
        links = ["docker_dind"];

        environment = {
          DOCKER_HOST = "tcp://docker_dind:2375";
        };

        volumes = [
          "${rwPath}/runner:/data"
        ];

        extraHosts = ["git.nelim.org:10.0.0.130"];
        networks = ["proxy_net"];
      };
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
