{...}: {
  imports = [
    ./docker
    ./homepage
    ./jellyfin
    ./llm
    ./mergerfs
    ./obsidian-livesync
    ./qbittorrent
    ./snapraid

    # TODO: I need to actually do this properly before unleashing it on my library
    # ./subtitles
  ];
}
