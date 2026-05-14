{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-UwoUWI0bJYVDAiuLjAS9moXvmONOlpKO7lI7Q7KMb5c=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
