pkgs:
pkgs.dockerTools.pullImage {
  imageName = "some/image/name";
  imageDigest = "";
  sha256 = "";
  finalImageName = "";
  finalImageTag = "latest";
}
