pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/cleanuparr/cleanuparr";
  imageDigest = "sha256:efd08729a33223a6a5bae267afcbeffe4bd2876b3f03144a025968adb8e3cc7e";
  hash = "sha256-wvsR2cP17XyQvgv3VdJpcAW2bMM8vY52a0wtBOt9uKA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
