pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:4193f3cc99bb4d99f53007f07d45e2efbcd531f4e81a765470b2cce433f33131";
  sha256 = "0vf7z4d0s543cx7xxz39gwjfvhb1xq41sk5486nhclybimj1j7lb";
  finalImageName = imageName;
  finalImageTag = "release";
}
