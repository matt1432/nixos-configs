{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-Ta9nMEvmEl0YkRSGPCOwhk0+gsdQTXgwJT8v3sMXSac=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
