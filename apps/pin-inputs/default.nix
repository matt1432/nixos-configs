{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-t5zNFTpIcXEXaPlMXsBBF03MPi35HVt8pdXEKaUfQsc=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
