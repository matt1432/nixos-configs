pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:5343937f18f2580300c5dbc0144df0994681fec2b8774e8a8ecee2d6c9f8c595";
  sha256 = "07gpwn63xsy9hfsp1pyx8lyshdkfv1ak3cbcidlz3aymflxcsjdb";
  finalImageName = imageName;
  finalImageTag = "9";
}
