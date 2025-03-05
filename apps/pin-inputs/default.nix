{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-mkt+K71mDdRrSz6/YiB/DsBmNjSBebgxXfW/O9XGSeY=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
