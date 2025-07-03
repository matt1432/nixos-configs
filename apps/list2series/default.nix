{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-p/EEjotM7O0vJhjzd02gYwkjNw6ZTsjW8t8fdSfZ+9c=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
