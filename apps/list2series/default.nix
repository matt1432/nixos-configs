{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-l+DjM0mA6+rF9aCOFumXbZCruixd/3hB6TX31oX0qwI=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
