{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-zb/YuACgQYfX0sKFt+eDjyawu+mufRwDEZd3KBrYZs0=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
