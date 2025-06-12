pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:6784fb0834aa7dbbe12e3d7471e69c290df3e6ba810dc38b34ae33d3c1c05f7d";
  hash = "sha256-3azBgYAFQijLOzWJrJrbrTYtHbXDvH22TJHMAFlVWUk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
