{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-bMu8H5pz+XrlmbMe/MKAgaoFOYQeV4u92Mg8mKHbdyQ=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
