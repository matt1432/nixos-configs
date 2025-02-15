{
  mainUID,
  mainGID,
  ...
}: {
  config,
  pkgs,
  ...
}: let
  inherit (config.sops) secrets;
in {
  virtualisation.docker.compose."gameyfin" = {
    networks.proxy_net = {external = true;};

    services."gameyfin" = {
      image = pkgs.callPackage ./images/gameyfin.nix pkgs;
      restart = "always";
      user = "${mainUID}:${mainGID}";

      env_file = [secrets.gameyfin.path];
      environment.GAMEYFIN_USER = "mathis";

      volumes = [
        "/data/games:/opt/gameyfin-library"
      ];

      expose = ["8080"];
      ports = ["8074:8080"];
      networks = ["proxy_net"];
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
