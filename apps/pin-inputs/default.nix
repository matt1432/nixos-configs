{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-Rju/t/yC8nUibD72NivZjg6oIy2ny/s7I+LlwLlS5cQ=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
