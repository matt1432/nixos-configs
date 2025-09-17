{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-ZWQR3KvVTJOo11vRequ5mFEluz+DO81Ift9sTKQNUS4=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
