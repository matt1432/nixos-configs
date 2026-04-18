{
  configPath,
  mainUID,
  mainGID,
  TZ,
  ...
}: {pkgs, ...}: let
  rwPath = configPath + "/media/cleanuparr";
in {
  virtualisation.docker.compose."cleanuparr" = {
    networks.proxy_net = {external = true;};

    services."cleanuparr" = {
      image = pkgs.callPackage ./images/cleanuparr.nix pkgs;
      restart = "always";

      ports = ["11011:11011"];

      volumes = [
        "${rwPath}/data:/config"
        # "/path/to/downloads:/downloads"
      ];

      environment = {
        PUID = mainUID;
        PGID = mainGID;
        inherit TZ;

        PORT = "11011";
        BASE_PATH = "/cleanuparr";
        UMASK="022";
      };

      networks = ["proxy_net"];

      healthcheck = {
        test = ["CMD" "curl" "-f" "http://localhost:11011/health"];
        start_period = "30s";
        interval = "30s";
        retries = 3;
        timeout = "10s";
      };
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
