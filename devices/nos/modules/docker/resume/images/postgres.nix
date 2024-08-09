pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:fa484d844b88ac34811daf3da66af1fd17e34b0e1ff5d1b6f904269c85890dc0";
  sha256 = "18bljw3bydqx9vmhqnky5xp2k2fmbpzw5569hnmj261nxq5n6dws";
  finalImageName = "postgres";
  finalImageTag = "15-alpine";
}
