{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-xllXwbvxYz7HKolKqpT0RZlHf7iYNZ8dWcpThRmrCmU=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
