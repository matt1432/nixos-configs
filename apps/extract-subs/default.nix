{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-XflXVdlsTonDHiR70Th/V6KUf4KSvcwnDod2mkz7rHQ=";

  runtimeInputs = [
    ffmpeg-full
  ];
}
