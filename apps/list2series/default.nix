{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-C6Ai0RzQlipWleOFhn3bq2WuqDz51D4oVIr1Co7JkmA=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
