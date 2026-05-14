pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:06aa3d7be10bc6307990c81bdca075793132e9163391abc370c015e344e23128";
  hash = "sha256-5Dhnlm+KE/Yk2Y73kOeCMSbknILKN9yjZCF7PSuMGhc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
