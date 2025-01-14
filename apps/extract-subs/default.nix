{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-7S1MkOSRqF5jKqfSOTD/pWnPZrbYewejXLOQ/gcSkUk=";

  runtimeInputs = [
    ffmpeg-full
  ];
}
