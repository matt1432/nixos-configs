pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:979bccfde35445db618c65107d27d08c6c21339d8dc3ad4c830c6633947be0e4";
  hash = "sha256-Na62E8Si/8awCr5dR1NflNtAVLYdlK/JKCVTJz1M9d4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
