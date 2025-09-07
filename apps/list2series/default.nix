{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-Ie3vHg0t8SFQwetQ8xZfzkfmSuUhYE5tI6m4ydBUt40=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
