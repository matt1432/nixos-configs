{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-wH8pzLvQHXBf9IrKYQBnD5OvWixHW3DTiDtnP/Ex6fE=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
