pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:922d38d4ca73ba5bfa8140c50b0d1f45636ca7b4c20d90506c49e2be2d7911f5";
  hash = "sha256-XuotDKF4TlptfGBvlNBJa0SGIUyZtEhrOIreF0woAPU=";
  finalImageName = imageName;
  finalImageTag = "14";
}
