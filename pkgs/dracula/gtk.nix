{
  gtk-theme-src,
  pkgs,
  ...
}:
pkgs.dracula-theme.overrideAttrs {
  version = gtk-theme-src.shortRev;
  src = gtk-theme-src;
}
