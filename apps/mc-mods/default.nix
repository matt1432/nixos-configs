{
  buildApp,
  nodejs_latest,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-i7D2zsxTy++jWS+JtJnF4GPvIqEkwiikggk7npk+I58=";

  runtimeInputs = [
    nodejs_latest
  ];

  meta.description = ''
    Checks if a list of mods have a version available for a specific Minecraft
    version and a specific loader.
  '';
}
