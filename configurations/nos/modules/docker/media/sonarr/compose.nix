rwDataDir: {pkgs, ...}: let
  rwPath = rwDataDir + "/media/sonarr";
in {
  virtualisation.docker.compose."sonarr" = {
    networks.proxy_net = {external = true;};

    services."sonarr" = {
      image = pkgs.callPackage ./images/sonarr.nix pkgs;
      restart = "always";

      ports = ["8989:8989"];

      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/New_York";
      };

      volumes = [
        "${rwPath}/data:/config"
        "/data:/data"
      ];

      cpus = 0.5;
      networks = ["proxy_net"];
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
