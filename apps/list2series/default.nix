{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-zkKWMuIKB+0yBqJH6aST/9C/wbEHs4l9XW1/CBnHxxw=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
