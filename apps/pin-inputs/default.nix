{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-zrv1gf+4ux9g+xnuHeWYt9PUYnX1AoUAxUD5e7+cyUU=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
