{
  pkgs,
  self,
  ...
}: let
  inherit (self.packages.${pkgs.system}) dracula;
in {
  imports = [
    ./gtk.nix
    ./qt.nix
  ];

  home.pointerCursor = {
    name = "Dracula-cursors";
    package = dracula.gtk;
    size = 24;

    gtk.enable = true;

    x11 = {
      enable = true;
      defaultCursor = "Dracula-cursors";
    };
  };

  xresources.extraConfig =
    builtins.readFile
    "${dracula.xresources}";
}
