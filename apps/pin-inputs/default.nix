{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-6bq4n8frTkIEPclqMmyBYpMu2cA9W4UlQtxdd4IZ45k=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
