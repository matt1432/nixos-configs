{
  rwPath,
  importImage,
  ...
}: {
  services = {
    "musicbot_be" = {
      container_name = "benis";
      hostImage = importImage ./images/jmusicbot.nix;
      restart = "always";

      volumes = [
        "${rwPath}/data/be/config.txt:/app/config.txt:ro"
        "${rwPath}/data/be/playlists:/app/playlists:rw"
      ];
    };

    "musicbot_br" = {
      container_name = "bruh";
      hostImage = importImage ./images/jmusicbot.nix;
      restart = "always";

      volumes = [
        "${rwPath}/data/br/config.txt:/app/config.txt:ro"
        "${rwPath}/data/br/playlists:/app/playlists:rw"
      ];
    };
  };
}
