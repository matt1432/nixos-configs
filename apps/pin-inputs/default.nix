{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-79epzZgBap5d7wwY3PvWbM97mZQVAQHXKBZM7tOUplk=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
