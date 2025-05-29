{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-mY9fhpQzvWore4+U6qi2SkOEyTpOWjvOqAOUqDSDhN0=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
