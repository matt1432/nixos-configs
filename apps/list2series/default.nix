{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-fKUlLnbAJHgn6W+Py48P1Z0QMQgRT5+jGxWh3wnLltw=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
