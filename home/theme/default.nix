{
  pkgs,
  ...
}: {
  imports = [
    ./gtk.nix
    ./qt.nix
  ];

  home.pointerCursor = {
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 24;

    gtk.enable = true;

    x11 = {
      enable = true;
      defaultCursor = "Dracula-cursors";
    };
  };

  xresources.extraConfig =
    builtins.readFile
    "${pkgs.dracula-theme}/xres";
}
