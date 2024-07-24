{
  config,
  pkgs,
  ...
}: let
  inherit (config.sops) secrets;
  inherit (config.khepri) rwDataDir;

  rwPath = rwDataDir + "/resume";
in {
  khepri.compositions."resume".services = {
    "postgres" = {
      image = import ./images/postgres.nix pkgs;
      restart = "always";

      ports = ["5432:5432"];

      volumes = [
        "${rwPath}/db:/var/lib/postgresql/data"
      ];

      environmentFiles = [secrets.resume.path];
    };

    "server" = {
      image = import ./images/resume-server.nix pkgs;
      restart = "always";

      ports = ["3100:3100"];

      dependsOn = ["postgres"];

      environmentFiles = [secrets.resume.path];

      environment = {
        PUBLIC_URL = "https://resume.nelim.org";
        PUBLIC_SERVER_URL = "https://resauth.nelim.org";
      };
    };

    "client" = {
      image = import ./images/resume-client.nix pkgs;
      restart = "always";

      ports = ["3060:3000"];

      dependsOn = ["server"];

      environment = {
        PUBLIC_URL = "https://resume.nelim.org";
        PUBLIC_SERVER_URL = "https://resauth.nelim.org";
      };
    };
  };
}
