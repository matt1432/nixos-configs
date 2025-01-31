rwDataDir: {pkgs, ...}: let
  rwPath = rwDataDir + "/media/radarr";
in {
  virtualisation.docker.compose."radarr" = {
    networks.proxy_net = {external = true;};

    services."radarr" = {
      image = pkgs.callPackage ./images/radarr.nix pkgs;
      restart = "always";

      ports = ["7878:7878"];

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
