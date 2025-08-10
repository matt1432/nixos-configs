{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-nf0DPOX/rVn5FYVfeOD2xR1p26rc+S+LLFk7oDKo/3Y=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
