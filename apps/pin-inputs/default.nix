{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-7EOWh7DUJ+uuj3oviG4P/rnozV9ost+dzrvmtjcZcgc=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
