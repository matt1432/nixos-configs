{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-i2J+mtLeLJhWDiz1c2Zt7ncrmPXDgR8l2nGYBFn3lFQ=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
