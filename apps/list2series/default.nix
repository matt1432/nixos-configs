{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-kMQnG8R+cQCPhWdOttBNmWTsDs8ZG7O4qw6TRqrAp2o=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
