{
  configPath,
  TZ,
  ...
}: {pkgs, ...}: let
  rwPath = configPath + "/media/seerr";
in {
  virtualisation.docker.compose."seerr" = {
    networks.proxy_net = {external = true;};

    services."seerr" = {
      init = true;

      image = pkgs.callPackage ./images/seerr.nix pkgs;
      restart = "always";

      environment = {
        LOG_LEVEL = "debug";
        inherit TZ;
      };

      volumes = [
        "${rwPath}/data:/app/config"
      ];

      networks = ["proxy_net"];
      ports = ["5055:5055"];

      healthcheck = {
        test = "wget --no-verbose --tries=1 --spider http://localhost:5055/api/v1/status || exit 1";
        start_period = "20s";
        timeout = "3s";
        interval = "15s";
        retries = "3";
      };
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
