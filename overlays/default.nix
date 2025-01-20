self: {
  misc-fixes = import ./misc-fixes;
  nix-version = import ./nix-version self;
  xdg-desktop-portal-kde = import ./xdg-desktop-portal-kde;
}
