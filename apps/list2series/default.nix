{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-P7Eyp3CjUh0tCCFl4jkiwf3nTtyKA02XOGqMbYpylTw=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
