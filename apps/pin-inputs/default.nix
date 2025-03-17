{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-Qmhx5S6eE37QQ/4/GLsHnPasX0UfCSJ/+n+1ClfEzWc=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
