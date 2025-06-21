{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-jYuKcBONl+BDHuVTBO0DND6MToV3iTyz1uWxZestKVo=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
