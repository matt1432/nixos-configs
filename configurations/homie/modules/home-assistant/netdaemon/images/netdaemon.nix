pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "netdaemon/netdaemon5";
  imageDigest = "sha256:3290c3a8112e0abb076d9a16e1b20e31c5a97e425cb4578e7406007f443dccb5";
  hash = "sha256-W/MlJejTpHsJfF+JyUKYKFoSUhvSS827IWpjYZQ0Tj0=";
  finalImageName = imageName;
  finalImageTag = "25.10.0";
}
