pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:8d1b7fc4896684b5fba93c34d2494d9176f7c5ab99bbd0e3a0535aeaa24a0fe1";
  sha256 = "0mhg4z6ydqz1hf4692pcxcakzr6n7rkwazkgkawl0s43wrak1bgx";
  finalImageName = "postgres";
  finalImageTag = "15-alpine";
}
