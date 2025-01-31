rwDataDir: {pkgs, ...}: let
  rwPath = rwDataDir + "/media/sabnzbd";
in {
  virtualisation.docker.compose."sabnzbd" = {
    networks.proxy_net = {external = true;};

    services."sabnzbd" = {
      image = pkgs.callPackage ./images/sabnzbd.nix pkgs;
      restart = "always";

      ports = ["8382:8082"];

      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/New_York";
      };

      volumes = [
        "${rwPath}/data:/config"
        "/data:/data"
      ];

      cpus = 2;
      networks = ["proxy_net"];
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
