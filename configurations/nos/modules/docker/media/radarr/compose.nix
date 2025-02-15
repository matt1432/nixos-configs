{
  configPath,
  mainUID,
  mainGID,
  TZ,
  ...
}: {pkgs, ...}: let
  rwPath = configPath + "/media/radarr";
in {
  virtualisation.docker.compose."radarr" = {
    networks.proxy_net = {external = true;};

    services."radarr" = {
      image = pkgs.callPackage ./images/radarr.nix pkgs;
      restart = "always";

      ports = ["7878:7878"];

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
