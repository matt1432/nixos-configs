{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-xDlDo8wWT1mSKvr8jDHoAWmohogxbHC2WX76B0yni+4=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
