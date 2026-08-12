{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-chxLEkM5nH/SkXJFpiAuBftaA5tqqxVf8p2lskjHgA8=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
