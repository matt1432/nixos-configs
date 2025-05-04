{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-CnLT+p4H3frKiQT8CGFIKN5VoSaWDQG/SDE2CDPN3Fg=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
