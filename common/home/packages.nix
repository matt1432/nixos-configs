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
      dig.dnsutils
      dracula-theme
      imagemagick
      killall
      mosh
      neofetch
      nix-output-monitor
      openssh
      progress
      rsync
      tree
      unzip
      usbutils
      wget
      zip
    ]);
}
