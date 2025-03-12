{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-YD+iKEwxMZLpTi/mTyGpzGgGj3EhAxMmG2O97Q4710E=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
