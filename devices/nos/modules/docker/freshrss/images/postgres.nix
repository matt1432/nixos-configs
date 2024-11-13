pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:9fcd27ebadf8d8fb1f257b1799eff6363cb0d947ffff046de5d49915f469ca08";
  sha256 = "0qjpwaprbj5rsqfzaablxg3ggqb104glia0g38fa8mgkijza0vb4";
  finalImageName = imageName;
  finalImageTag = "14";
}
