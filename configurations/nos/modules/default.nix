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

    # FIXME: I need to actually do this properly before unleashing it on my library
    # ./subtitles
  ];
}
