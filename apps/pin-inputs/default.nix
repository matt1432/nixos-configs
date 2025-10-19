{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-61tunK3xuwU56Sr4Tt0Kmnl+4zlHFBl2x1a4WNnUqlk=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
