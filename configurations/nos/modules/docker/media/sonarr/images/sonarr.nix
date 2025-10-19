pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:69d72f525bc181728c8f4788992a28ae1cd797ddd978f48bc2e271c7acd02e9b";
  hash = "sha256-R4WKRbf1Ou6KPs6chLpOXpsjLO1IVzan564IRiU7pkg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
