{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-nsAJM8BnZOmXOUazZNYu7fBK7BqKVNxVqQVyqqumaCI=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
