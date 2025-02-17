{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-qNTgtT+x1O1jMWYgs8pXy3fUJKHBnf9adhR9nD5V7TY=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
