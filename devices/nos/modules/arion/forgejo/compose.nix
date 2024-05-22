{config, ...}: let
  inherit (config.sops) secrets;
  inherit (config.arion) rwDataDir;

  rwPath = rwDataDir + "/forgejo";
in {
  arion.projects."forgejo" = {
    "forgejo" = {
      image = ./images/forgejo.nix;

      ports = [
        # Redirect WAN port 22 to this port
        "2222:22"
        "3000:3000"
      ];

      restart = "always";
      depends_on = ["forgejo-db"];

      env_file = [secrets.forgejo.path];
      environment = {
        APP_NAME = "Gitea";

        # TODO: change ids
        USER_UID = "1000";
        USER_GID = "1000";

        ROOT_URL = "https://git.nelim.org";
        SSH_DOMAIN = "git.nelim.org";
        SSH_PORT = 22;
        HTTP_PORT = 3000;
      };

      volumes = [
        "${rwPath}/data:/data"
        "/etc/timezone:/etc/timezone:ro"
        "/etc/localtime:/etc/localtime:ro"
      ];
    };

    "forgejo-db" = {
      image = ./images/postgres.nix;

      restart = "always";

      env_file = [secrets.forgejo-db.path];

      volumes = ["${rwPath}/db:/var/lib/postgresql/data"];
    };

    "act_runner" = {
      image = ./images/act_runner.nix;
      privileged = true;

      restart = "always";
      depends_on = ["forgejo"];

      env_file = [secrets.forgejo-runner.path];
      environment = {
        GITEA_INSTANCE_URL = "https://git.nelim.org";
        GITEA_RUNNER_NAME = "DinD";
      };

      volumes = ["${rwPath}/act:/data"];

      extra_hosts = [
        "git.nelim.org=10.0.0.130"
      ];
    };
  };
}
