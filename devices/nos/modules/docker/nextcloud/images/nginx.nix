pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:447a8665cc1dab95b1ca778e162215839ccbb9189104c79d7ec3a81e14577add";
  sha256 = "08i0z4p04103k5bv8jd730d7fiz4jf4hq6abqjccl9skn8f0ghjw";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
