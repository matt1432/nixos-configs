pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:daf9e7e660b74c3d58543e0bdb406c281e93a72e2c7729c418e68b41b5f59af2";
  hash = "sha256-tE1HB3dHqRzwOkvKx7ZKfmyAm9UoMrP0x+DQOIwUQBE=";
  finalImageName = imageName;
  finalImageTag = "14";
}
