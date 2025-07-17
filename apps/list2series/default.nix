{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-XjCKnLtXulqSt5iwFyDttVaPfKvIXtLBc+5DNU8rf64=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
