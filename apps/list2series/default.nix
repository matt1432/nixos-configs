{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-7DNUgSJ9lS2McrxzgjjPjNBxGEx1XYqTpGpd5eJkBNU=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
