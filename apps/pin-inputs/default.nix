{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-GYMPldjPfgljsq1M2paZnOAVya4mn940WZRNVTJ5R1o=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
