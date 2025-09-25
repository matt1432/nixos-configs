{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-a4QZnDGZZogbIjswOTLFieIDkw3IJ409lkXMpM5Oev4=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
