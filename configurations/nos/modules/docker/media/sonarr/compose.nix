{
  configPath,
  mainUID,
  mainGID,
  TZ,
  ...
}: {pkgs, ...}: let
  rwPath = configPath + "/media/sonarr";
in {
  virtualisation.docker.compose."sonarr" = {
    networks.proxy_net = {external = true;};

    services."sonarr" = {
      image = pkgs.callPackage ./images/sonarr.nix pkgs;
      restart = "always";

      ports = ["8989:8989"];

      environment = {
        PUID = mainUID;
        PGID = mainGID;
        inherit TZ;
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
