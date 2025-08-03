{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-q9rMm2b1PbVPUqaT7AoOoq6SZmfF1smr+JyNWXAu0W4=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
