pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:341bf0f3ce6c5277d6002cf6e1fb0319fa4252add24ab6a0e262e0056d313208";
  hash = "sha256-PB6od0JAanSZSc6Gl2ttjMp4gQgU3SLmzl81tqAaq5U=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
