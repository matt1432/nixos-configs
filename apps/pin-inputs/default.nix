{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-ZofvMJlZF3znFIPCeVgfjO/desMHYcxwA09E5q9KqUI=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
