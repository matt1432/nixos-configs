pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "21hsmw/flaresolverr";
  imageDigest = "sha256:506b7f26aaf10e8c07ab22f74a7eea31eca66e263fe52d570b7bc0ef29952db9";
  sha256 = "1ll5f62r69hzizli0irpp1z1r4hmv9ps3pqzb1s8klvjrdgaxd22";
  finalImageName = imageName;
  finalImageTag = "nodriver";
}
