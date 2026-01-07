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
        depends_on = ["flaresolverr" "ygege"];
      };

      "ygege" = {
        image = pkgs.callPackage ./images/ygege.nix pkgs;
        restart = "always";

        volumes = [
          "${rwPath}/ygege/sessions:/app/sessions"
          "${rwPath}/ygege/config.json:/app/config.json"
        ];

        ports = ["8715:8715"];
        networks = ["proxy_net"];
      };

      "flaresolverr" = {
        image = pkgs.callPackage ./images/flaresolverr.nix pkgs;
        restart = "always";

        environment = {
          inherit TZ;
        };

        shm_size = "2gb";

        ports = ["8191:8191"];

        networks = ["proxy_net"];
      };
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
