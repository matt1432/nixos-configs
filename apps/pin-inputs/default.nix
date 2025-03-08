{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-R+ojQh8XsiXYTerSvbnjPw9ByD+fSf4GGtH3m8mqm4Y=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
