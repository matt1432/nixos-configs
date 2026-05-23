pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:a209aced4fa19381231fae4d9a4c5816f7691294f13572f8bddc082ba32e1c7c";
  hash = "sha256-IFolV3lbS7Q6ZjbDNqGzR2CJ26WqNLsMbTSqq+HvYqU=";
  finalImageName = imageName;
  finalImageTag = "14";
}
