{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-RaqAstn1I71YbR1VAEfA9RZf5EDZ8SfsyssiHvSvNFA=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
