{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-mCpJ7lVewF/Xy8x8muFfyr2eE5spWaGFeG9ur6kgctU=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
