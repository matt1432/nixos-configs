pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker";
  imageDigest = "sha256:12e683a161823b2a839aeea999b9d960e6e1f9a97b1679ad6b441982e2d9cf07";
  hash = "sha256-giWxsJ1y7/AhBCxCTbVGx4zc3+Un77dVR2G/wOjKtls=";
  finalImageName = imageName;
  finalImageTag = "dind";
}
