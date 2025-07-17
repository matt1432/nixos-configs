pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:08f370d7d22c8526333a23be8dfd744dfdfb0c4973a2af421db0f5fe45562ba1";
  hash = "sha256-UMe16WWF1hewSZf6P1nUCnfUfBotAZklXRajVRrxN3s=";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
