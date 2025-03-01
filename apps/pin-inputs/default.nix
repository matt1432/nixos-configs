{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-z9KkaDJy4+9H0U0Wb5AYNScFW2lwU0l8U+YUm0lnVvE=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
