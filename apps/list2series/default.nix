{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-k2yowHwviC1MUCV1YAw27VdWSJut56/oiSa7l417iso=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
