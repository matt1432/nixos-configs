{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-O1a+US9uiTn5kKHRcv+j1P8cC9dNQUKLtIOF/r0ggUQ=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
