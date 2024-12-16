{...}: {
  imports = [
    ./docker
    ./homepage.nix
    ./jellyfin
    ./qbittorrent
    # FIXME: I need to actually do this properly before unleashing it on my library
    # ./subtitles
    ./llm.nix
    ./mergerfs.nix
    ./snapraid.nix
  ];
}
