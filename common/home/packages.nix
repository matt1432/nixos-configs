{
  config,
  pkgs,
  ...
}: {
  home.packages =
    (with config.customPkgs; [
      pokemon-colorscripts
      repl
    ])
    ++ (with pkgs.nodePackages; [
      undollar
    ])
    ++ (with pkgs; [
      dracula-theme
      neofetch
      progress
      wget
      tree
      mosh
      rsync
      killall
      imagemagick
      usbutils
      zip
      dig.dnsutils
    ]);
}
