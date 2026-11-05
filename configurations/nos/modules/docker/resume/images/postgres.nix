pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:3a4264520e121176619f54ff867d12774bc81e95e7b84db58d63bccdb6144b81";
  hash = "sha256-Na62E8Si/8awCr5dR1NflNtAVLYdlK/JKCVTJz1M9d4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
