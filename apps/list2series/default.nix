{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-KEqbPUAMQHYdTdAF8zrPINIyhqXgELS8pe/BOpcaihg=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
