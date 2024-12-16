{
  config,
  pkgs,
  ...
}: let
  inherit (config.sops) secrets;
  inherit (config.khepri) rwDataDir;

  rwPath = rwDataDir + "/forgejo";
in {
  khepri.compositions."forgejo" = {
    networks.proxy_net = {external = true;};

    services = {
      "forgejo" = {
        image = import ./images/forgejo.nix pkgs;

        ports = [
          # Redirect WAN port 22 to this port
          "2222:22"
          "3000:3000"
        ];

        networks = ["proxy_net"];

        restart = "always";
        dependsOn = ["forgejo-db"];

        environmentFiles = [secrets.forgejo.path];
        environment = {
          APP_NAME = "Gitea";

          # TODO: change ids
          USER_UID = "1000";
          USER_GID = "1000";

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
        image = import ./images/postgres.nix pkgs;

        restart = "always";

        environmentFiles = [secrets.forgejo-db.path];
        networks = ["proxy_net"];

        volumes = ["${rwPath}/db:/var/lib/postgresql/data"];
      };

      "act_runner" = {
        image = import ./images/act_runner.nix pkgs;

        privileged = true;
        user = "root:root";
        networks = ["proxy_net"];

        restart = "always";
        dependsOn = ["forgejo"];

        environmentFiles = [secrets.forgejo-runner.path];
        environment = {
          GITEA_INSTANCE_URL = "https://git.nelim.org";
          GITEA_RUNNER_NAME = "DinD";
        };

        volumes = ["${rwPath}/act:/data"];
        extraHosts = ["git.nelim.org:10.0.0.130"];
      };
    };
  };
}
