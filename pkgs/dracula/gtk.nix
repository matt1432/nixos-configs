{
  gtk-theme-src,
  pkgs,
  ...
}:
pkgs.dracula-theme.overrideAttrs (o: {
  version = o.version + "+" + gtk-theme-src.shortRev;
  src = gtk-theme-src;
})
