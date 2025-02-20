{
  buildApp,
  nodejs_latest,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-L4GX01M8/Q+9Kv+F2sYuhBVJrGv9V4fz4GyXQ/7IQn8=";

  runtimeInputs = [
    nodejs_latest
  ];

  meta.description = ''
    Checks if a list of mods have a version available for a specific Minecraft
    version and a specific loader.
  '';
}
