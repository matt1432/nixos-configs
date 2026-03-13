{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-Sm7hNFdZ3VNLx2Cmzo3GT5M8eJJwoZiXSX6a9D1biLc=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
