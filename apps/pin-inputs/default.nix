{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-/cAQCV+gR65eh6rCEgQouUxqMfQX9kAxNL9+HTQBGoU=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
