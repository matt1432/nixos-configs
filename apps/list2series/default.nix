{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-iQBst+yiIh/EGF5O/0D8V5xVzXZWS19NPL/wxT5IUbo=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
