{
  config,
  rwPath,
  ...
}: let
  secrets = config.sops.secrets;
in {
  services = {
    "forgejo" = {
      image = "codeberg.org/forgejo/forgejo:1.21.3-0";
      container_name = "forgejo";

      ports = [
        # Redirect WAN port 22 to this port
        "2222:22"
        "3000:3000"
      ];

      restart = "always";
      privileged = true;
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

    "runner" = {
      image = "gitea/act_runner";

      # TODO: change name
      container_name = "podman-runner";

      restart = "always";
      depends_on = ["forgejo"];

      volumes = [
        "${secrets.forgejo-runner.path}:/data/.runner"
        "/var/run/docker.sock:/var/run/docker.sock"
      ];
    };

    "forgejo-db" = {
      image = "public.ecr.aws/docker/library/postgres:14";
      container_name = "forgejo-db";
      restart = "always";

      env_file = [secrets.forgejo-db.path];

      volumes = ["${rwPath}/db:/var/lib/postgresql/data"];
    };
  };
}
