{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-qobKK9NSbz4kGoFqvb+IpfCbQfM/dWMti6dhXMEUt1c=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
