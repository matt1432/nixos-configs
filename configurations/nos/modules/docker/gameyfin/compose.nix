{
  configPath,
  mainUID,
  mainGID,
  ...
}: {
  config,
  pkgs,
  ...
}: let
  inherit (config.sops) secrets;

  rwPath = configPath + "/gameyfin";
in {
  virtualisation.docker.compose."gameyfin" = {
    networks.proxy_net = {external = true;};

    services."gameyfin" = {
      image = pkgs.callPackage ./images/gameyfin.nix pkgs;
      restart = "always";

      environment = {
        APP_URL = "https://games.nelim.org";
        PUID = mainUID;
        PGID = mainGID;
      };

      env_file = [secrets.gameyfin.path];

      volumes = [
        "${rwPath}/db:/opt/gameyfin/db"
        "${rwPath}/data:/opt/gameyfin/data"
        "${rwPath}/logs:/opt/gameyfin/logs"
        "/data/games:/opt/gameyfin-library"
      ];

      ports = ["8074:8080"];
      networks = ["proxy_net"];
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
