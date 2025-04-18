{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-7siUjfZbkPZXCwrhWeg2NoThHdBtULJXueXr1+wGmuY=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
