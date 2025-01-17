{...}: {
  imports = [
    ./docker
    ./homepage
    ./jellyfin
    ./qbittorrent
    # FIXME: I need to actually do this properly before unleashing it on my library
    # ./subtitles
    ./llm
    ./mergerfs
    ./snapraid
  ];
}
