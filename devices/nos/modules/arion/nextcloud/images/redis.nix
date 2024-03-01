pkgs:
pkgs.dockerTools.pullImage {
  imageName = "redis";
  imageDigest = "sha256:558d0845026fe0bf091a00c0ad647ffacf9df385d780d433ca70661f7276f834";
  sha256 = "0bbbzjl2fc2wvwj45j4z8kff2fj82qjk5nsgi79bqzm72x428mjb";
  finalImageName = "redis";
  finalImageTag = "7.0.0-alpine";
}
