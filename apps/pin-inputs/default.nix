{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-wsOnjqj063QiygmUek8C71qGPBJ8+0I4BIganuVVp+k=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
