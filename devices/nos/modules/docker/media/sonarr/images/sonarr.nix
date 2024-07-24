pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:fbee5770f688e4f89dd073534feda11251bfde0e0a4e6ac74dd8c33bb856b505";
  sha256 = "0w58dqqbk03akxj3z418fh1vsn3pipjwrvjrs5ajgylallha9ypf";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
