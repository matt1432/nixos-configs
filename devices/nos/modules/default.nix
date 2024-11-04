{...}: {
  imports = [
    ./docker
    ./homepage.nix
    ./jellyfin
    ./qbittorrent
    ./subtitles
    ./llm.nix
    ./mergerfs.nix
    ./snapraid.nix
  ];
}
