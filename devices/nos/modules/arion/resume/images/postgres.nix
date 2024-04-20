pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:8a8d55343d6fc456cb183453e3094ff140b984157b36b48f817dd581654f2aec";
  sha256 = "0mhg4z6ydqz1hf4692pcxcakzr6n7rkwazkgkawl0s43wrak1bgx";
  finalImageName = "postgres";
  finalImageTag = "15-alpine";
}
