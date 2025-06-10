pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:2985f77749c75e90d340b8538dbf55d4e5b2c5396b2f05b7add61a7d8cd50a99";
  hash = "sha256-Cu43bHrBox6gQWM6rl8hX81MuXbHIYpMVBsJSg95g7A=";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
