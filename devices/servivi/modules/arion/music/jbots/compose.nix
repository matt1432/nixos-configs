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
        "${rwPath}/be/config.txt:/app/config.txt:ro"
        "${rwPath}/be/playlists:/app/playlists:rw"
      ];
    };

    "musicbot_br" = {
      container_name = "bruh";
      hostImage = importImage ./images/jmusicbot.nix;
      restart = "always";

      volumes = [
        "${rwPath}/br/config.txt:/app/config.txt:ro"
        "${rwPath}/br/playlists:/app/playlists:rw"
      ];
    };
  };
}
