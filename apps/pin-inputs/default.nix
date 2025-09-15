{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-ZjntSROgK4qPB3M0005m+lyvAnkLKpfJFomfJOVRrz0=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
