{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-TnglD2ZfYO1nAC1X9Fe5xEU0ajfhnIw2tpguV2MWeho=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
