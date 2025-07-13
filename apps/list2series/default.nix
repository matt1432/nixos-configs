{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-TZBS0pbTjEVbP5nRlCRZlW5JsxxWgnzUEc+qA0QEzE0=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
