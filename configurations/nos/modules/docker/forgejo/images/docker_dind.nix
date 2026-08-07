pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker";
  imageDigest = "sha256:e8faad5a8dc5279dff929afc5449f2791736912fff9f99351d742db2fad01b4c";
  hash = "sha256-LLiYDwhXnMKtcMNaIhM0lCxoybqWV3zEq2/s5YKfHoc=";
  finalImageName = imageName;
  finalImageTag = "dind";
}
