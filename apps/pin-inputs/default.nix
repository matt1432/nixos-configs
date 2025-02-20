{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-h43MJ9s1Gk0FZfvfqcHS7iNTpFe8SIPvBysWGxevTsw=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
