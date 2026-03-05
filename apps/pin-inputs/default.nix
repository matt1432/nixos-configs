{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-vPz9qMIN/qwHTU+WRHkq+qeevhPIqYuaYn8Oi3STDM8=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
