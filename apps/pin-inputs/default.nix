{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-nleqRzj8ix1XdpchD29dmGK++blACJriC8UwWgPdgZU=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
