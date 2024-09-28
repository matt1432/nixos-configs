pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:626046694f31a4a6a92511bbeca43f7e78ea8c6ae2f2ed70bbaa9b9abd5b67ab";
  sha256 = "1z0rq47apkk5y5qlpd9yqsdhgz2vzkslnrmm4m2dxzq394h0nmbh";
  finalImageName = "postgres";
  finalImageTag = "14";
}
