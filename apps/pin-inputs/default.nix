{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-GgcS2/g0b4VjwaSVaiytX8z8E4JmbmrjU5jnELUpR/A=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
