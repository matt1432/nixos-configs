pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:ede3a168dae0d2154440c2b1b2c7773201bfa969d85a1859c44b6f4ab2df0ef7";
  sha256 = "0g5qdcg07zcspicrcppi1kj9jxk528hqx7k6hjhlg53vy3g6pjyj";
  finalImageName = "postgres";
  finalImageTag = "15-alpine";
}
