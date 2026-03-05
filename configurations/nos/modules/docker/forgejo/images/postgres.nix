pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:980f2ff9f2d8e4eff5c7f53b54392ad5a43eb2d1193d37f91a1ff59a75b77ee3";
  hash = "sha256-/JpsaY3VklssKxUw+HWm8dBEbW4VMnefivlCI2e678A=";
  finalImageName = imageName;
  finalImageTag = "14";
}
