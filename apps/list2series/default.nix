{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-FWoTve8t13G+RZwEHxhYyyTtoBhcB+kyQLMmD9aJgIU=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
