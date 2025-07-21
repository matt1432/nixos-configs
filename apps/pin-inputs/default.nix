{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-b3oEvBd+DQ9nCrtguTJ1L2etziT5pTaOP/Pi6Vyxl2Q=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
