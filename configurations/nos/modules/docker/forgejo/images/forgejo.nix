pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:a3e33d03e771d3e58b27de5573c3a25dc4f670583a6724c1878a6d0bbecf3556";
  hash = "sha256-G4BvoKyklswS3h5KKyR3UxBcD+JY0FIg3SE8jNIrSCc=";
  finalImageName = imageName;
  finalImageTag = "16";
}
