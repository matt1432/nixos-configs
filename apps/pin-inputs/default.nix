{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-viWwLU8Due0Djc/wjou41Dms+S7sfl1LJbmIw7lvHKA=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
