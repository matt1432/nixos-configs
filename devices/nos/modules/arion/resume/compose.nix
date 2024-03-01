{config, ...}: let
  inherit (config.sops) secrets;
  inherit (config.arion) rwDataDir;

  rwPath = rwDataDir + "/resume";
in {
  arion.projects."resume" = {
    "postgres" = {
      image = ./images/postgres.nix;
      restart = "always";

      ports = ["5432:5432"];

      volumes = [
        "${rwPath}/db:/var/lib/postgresql/data"
      ];

      env_file = [secrets.resume.path];
    };

    "server" = {
      image = ./images/resume-server.nix;
      restart = "always";

      ports = ["3100:3100"];

      depends_on = ["postgres"];

      env_file = [secrets.resume.path];

      environment = {
        PUBLIC_URL = "https://resume.nelim.org";
        PUBLIC_SERVER_URL = "https://resauth.nelim.org";
      };
    };

    "client" = {
      image = ./images/resume-client.nix;
      restart = "always";

      ports = ["3060:3000"];

      depends_on = ["server"];

      environment = {
        PUBLIC_URL = "https://resume.nelim.org";
        PUBLIC_SERVER_URL = "https://resauth.nelim.org";
      };
    };
  };
}
