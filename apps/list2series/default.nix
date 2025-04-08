{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-KHd2+rZvGRi1dqAfH80M9LITgEHZ3IGUE5mdGBRwDyo=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
