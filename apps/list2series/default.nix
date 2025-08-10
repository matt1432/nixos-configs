{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-hS5+8HdYXrkUfHgggLgXtkOvWRpsPTMfZX9AhPHxlKU=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
