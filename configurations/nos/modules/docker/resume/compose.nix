rwDataDir: {
  config,
  pkgs,
  ...
}: let
  inherit (config.sops) secrets;

  rwPath = rwDataDir + "/resume";
in {
  virtualisation.docker.compose."resume" = {
    networks.proxy_net = {external = true;};

    services = {
      "postgres" = {
        image = pkgs.callPackage ./images/postgres.nix pkgs;
        restart = "always";

        ports = ["5432:5432"];

        volumes = [
          "${rwPath}/db:/var/lib/postgresql/data"
        ];

        env_file = [secrets.resume.path];
        networks = ["proxy_net"];
      };

      "server" = {
        image = pkgs.callPackage ./images/resume-server.nix pkgs;
        restart = "always";

        ports = ["3100:3100"];

        depends_on = ["postgres"];

        env_file = [secrets.resume.path];

        environment = {
          PUBLIC_URL = "https://resume.nelim.org";
          PUBLIC_SERVER_URL = "https://resauth.nelim.org";
        };
        networks = ["proxy_net"];
      };

      "client" = {
        image = pkgs.callPackage ./images/resume-client.nix pkgs;
        restart = "always";

        ports = ["3060:3000"];

        depends_on = ["server"];

        environment = {
          PUBLIC_URL = "https://resume.nelim.org";
          PUBLIC_SERVER_URL = "https://resauth.nelim.org";
        };
        networks = ["proxy_net"];
      };
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
