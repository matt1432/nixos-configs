{
  buildApp,
  ffmpeg-full,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-ytaO1mqoORNB5rP/8X/WpIoHkxmi1+Pc6Nep02+fTZ8=";

  runtimeInputs = [
    ffmpeg-full
  ];
}
