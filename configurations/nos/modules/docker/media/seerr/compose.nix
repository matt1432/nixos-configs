rwDataDir: {pkgs, ...}: let
  rwPath = rwDataDir + "/media/seerr";
in {
  virtualisation.docker.compose."seerr" = {
    networks.proxy_net = {external = true;};

    services."seerr" = {
      image = pkgs.callPackage ./images/jellyseerr.nix pkgs;
      restart = "always";

      environment = {
        LOG_LEVEL = "debug";
        TZ = "America/New_York";
      };

      volumes = [
        "${rwPath}/data:/app/config"
      ];

      networks = ["proxy_net"];
      ports = ["5055:5055"];
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
