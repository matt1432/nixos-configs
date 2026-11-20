{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-VlGxUYyos979hc4cqFrg2m5G8jN73hdFdGp1Tao27dk=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
