{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-A5xtspKUPJaVtJYKNnGNXg1A+u0rg7J7HbDu+dE6sHs=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
