self: {
  build-failures = import ./build-failures;
  nix-version = import ./nix-version self;
  xdg-desktop-portal-kde = import ./xdg-desktop-portal-kde;
}
