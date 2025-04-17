{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-uqLLmVbpHM5MIGNlHeLYAhWBYaNDW4oRyGJ0azou1Es=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
