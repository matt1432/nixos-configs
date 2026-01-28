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

    # FIXME: deleted '/data/history/Apocalypse - Never-Ending War 1918-1926 (2018) [imdbid-tt8561666]'?
    # ./subtitles
  ];
}
