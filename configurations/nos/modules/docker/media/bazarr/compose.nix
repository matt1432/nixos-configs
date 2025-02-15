{
  configPath,
  mainUID,
  mainGID,
  TZ,
  ...
}: {pkgs, ...}: let
  rwPath = configPath + "/media/bazarr";
in {
  virtualisation.docker.compose."bazarr" = {
    networks.proxy_net = {external = true;};

    services."bazarr" = {
      image = pkgs.callPackage ./images/bazarr.nix pkgs;
      restart = "always";

      environment = {
        PUID = mainUID;
        PGID = mainGID;
        inherit TZ;
      };

      ports = [
        "6767:6767"
      ];

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
