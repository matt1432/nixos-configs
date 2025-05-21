{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-otWZl9zIHy79RxeyEczse6lKoqPdVXHNwFjIvGg6ezI=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
