{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-qIy6kZtFzi6nSxLdJQlnHojCBA52//bxbXvyMdWjSt0=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
