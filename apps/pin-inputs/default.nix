{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-OOFJb3eV4J0sG29YVI8MF9DXn528eLvJw7nF80llbg0=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
