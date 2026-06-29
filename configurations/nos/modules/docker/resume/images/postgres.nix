pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:4aabea78cf39b90e834caf3af7d602a18565f6fe2508705c8d01aa63245c2e20";
  hash = "sha256-T4kBkeX1XLcEv8NhkUw0w1JinYmoLaEBhnuaJXrS0J0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
