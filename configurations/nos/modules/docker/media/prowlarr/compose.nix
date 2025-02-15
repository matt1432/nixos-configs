{
  configPath,
  mainUID,
  mainGID,
  TZ,
  ...
}: {pkgs, ...}: let
  rwPath = configPath + "/media/prowlarr";
in {
  virtualisation.docker.compose."prowlarr" = {
    networks.proxy_net = {external = true;};

    services = {
      "prowlarr" = {
        image = pkgs.callPackage ./images/prowlarr.nix pkgs;
        restart = "always";

        environment = {
          PUID = mainUID;
          PGID = mainGID;
          inherit TZ;
        };

        volumes = ["${rwPath}/data:/config"];

        ports = ["9696:9696"];
        networks = ["proxy_net"];
      };

      "flaresolverr" = {
        image = pkgs.callPackage ./images/flaresolverr.nix pkgs;
        restart = "always";

        environment = {
          LOG_LEVEL = "info";
          LOG_HTML = "false";
          CAPTCHA_SOLVER = "none";
          inherit TZ;

          # https://github.com/FlareSolverr/FlareSolverr/pull/1300#issuecomment-2379596654
          DRIVER = "nodriver";
        };

        ports = ["8191:8191"];

        depends_on = ["prowlarr"];
        networks = ["proxy_net"];
      };
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
