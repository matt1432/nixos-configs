{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-yROhjaYYiJcocMSioScz0XZ5Wbv6uThkgm5CvE0fEIw=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
