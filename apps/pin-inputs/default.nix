{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-dQTjRREVtFdj5bnn+mzeFe6vIZaFbFajSz+rYZx+St4=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
