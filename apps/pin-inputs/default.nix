{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-ziWwF9RnTGFvWOpnWQkF3+TzgGqvDflgEjEiIm8FlP0=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
