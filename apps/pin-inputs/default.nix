{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-5E1tNoLxofn3R/PuCiGsTVTOieY7R+nyfdTh/BhHjRo=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
