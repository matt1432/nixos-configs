{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-Hb7l9STXfFWfaDtwDPj/qDtl1cGFX52YjfylE1egiYI=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
