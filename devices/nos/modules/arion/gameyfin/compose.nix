{config, ...}: let
  inherit (config.sops) secrets;
in {
  arion.projects."gameyfin"."gameyfin" = {
    image = ./images/gameyfin.nix;
    restart = "always";
    user = "1000:1000";

    env_file = [secrets.gameyfin.path];
    environment.GAMEYFIN_USER = "mathis";

    volumes = [
      "/data/games:/opt/gameyfin-library"
    ];

    expose = ["8080"];
    ports = ["8074:8080"];
  };
}
