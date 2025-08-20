{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-2dd9mnhXacwzYBUM+DFX0fPxIdmJ8gwoGi1i2nVFiRs=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
