pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "some/image/name";
  imageDigest = "";
  sha256 = "";
  finalImageName = imageName;
  finalImageTag = "latest";
}
