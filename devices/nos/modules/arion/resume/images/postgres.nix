pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:90f25fbf7ea2cf70d6a6a2f9c475c5a297c2b41e15eddaa5d9d8fafc9146072c";
  sha256 = "0mhg4z6ydqz1hf4692pcxcakzr6n7rkwazkgkawl0s43wrak1bgx";
  finalImageName = "postgres";
  finalImageTag = "15-alpine";
}
