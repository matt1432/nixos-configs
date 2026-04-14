{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-ceUsdD5QW8jMKXCg/SFdVF6EFO7L9hnCRINMVdsypQg=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
