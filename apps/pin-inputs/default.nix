{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-DyI/RdxOf5C6mB3IO+aR9Nnze3bgQURCP+b/GF1vxio=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
