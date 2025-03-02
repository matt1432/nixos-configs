{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-kGxmG3UmWdOPkv/MWXfUzQgDqXf+pdUFDhr1zsJjTII=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
