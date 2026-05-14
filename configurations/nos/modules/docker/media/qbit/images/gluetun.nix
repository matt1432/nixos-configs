pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:bd84f4f090ca61170c8329a72d4f451255b01f6489486a621bfcb89749fb80ab";
  hash = "sha256-lrknWwYhN0hF0nP0ngpn0V3xRYoqJMZcwqT+YE/CZqk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
