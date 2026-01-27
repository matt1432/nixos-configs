{...}: {
  imports = [
    ./comics
    ./docker
    ./homepage
    ./jellyfin
    ./jmusicbot

    # TODO: re-enable this when homie is back up
    # ./llm

    ./mergerfs
    ./qbittorrent
    ./snapraid
    ./subtitles
  ];
}
