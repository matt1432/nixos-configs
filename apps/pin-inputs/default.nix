{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-mzXb7hfJkY6Dgb7MHRbFS1CC56K+VcggrZ1Hu5BaMS8=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
