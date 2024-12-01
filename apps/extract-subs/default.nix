{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-GiqSQv5yv6DVYoyc74HUPMhDkqi3mn8s8KxHOLNs/Rg=";

  runtimeInputs = [
    ffmpeg-full
  ];
}
