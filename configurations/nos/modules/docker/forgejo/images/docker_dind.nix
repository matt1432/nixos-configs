pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker";
  imageDigest = "sha256:08a98015fce594af7c382883bea080ea206de74402a95da9dc52b6428c8cd121";
  hash = "sha256-dqaHgAXuNBWxgLJvFtgqMM06gW+40RMsXh57DVBg5Cs=";
  finalImageName = imageName;
  finalImageTag = "dind";
}
