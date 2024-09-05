{...}: {
  imports = [
    ./docker
    ./jellyfin
    ./qbittorrent
    ./subtitles
    ./llm.nix
    ./mergerfs.nix
    ./snapraid.nix
  ];
}
