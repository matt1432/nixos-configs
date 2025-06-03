{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-4+JdRDVvr28sw4vsYnhtOY6S8+uKw6NMTb6lpY5T0g4=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
