{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-EvjUL+8Yetqg3f0KKVLiF7OnMtggtw6aI9nwICc3RN0=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
