pkgs:
pkgs.dockerTools.pullImage {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:ba008a8ff0d29199fa46cd7b7397d7cc734a9bb3a1fa7842a49b529469540399";
  sha256 = "1ifdbas5lcig6j5q9wnw5ms7nir4199ap7a2fgr44lvr1q4pysrb";
  finalImageName = "onlyoffice/documentserver";
  finalImageTag = "latest";
}
