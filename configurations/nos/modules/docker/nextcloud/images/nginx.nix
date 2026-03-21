pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:dec7a90bd0973b076832dc56933fe876bc014929e14b4ec49923951405370112";
  hash = "sha256-2aLktDK6rnpDO2Xv+OG54C186nKhZT/iTeO3s6IXrEs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
