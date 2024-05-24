pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:0cec11eaf51a9af24c27a09cae9840a9234336e5bf9edc5fdf67b3174ba05210";
  sha256 = "1n6amn216l17sah7kj2lax9s1rhz09k5axh18v2caz3r0f6srsw5";
  finalImageName = "postgres";
  finalImageTag = "15-alpine";
}
