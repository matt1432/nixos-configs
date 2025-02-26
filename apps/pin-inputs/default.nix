{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-WLkOBcjCfR/uzGBOWlEohpoR1lJfcd1JZ3CyxcghGLc=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
