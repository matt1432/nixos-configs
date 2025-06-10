{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-CSbRoAM2GTIrsh3S8z19LvW5KSeuGzLhHSZ7js3ymJc=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
