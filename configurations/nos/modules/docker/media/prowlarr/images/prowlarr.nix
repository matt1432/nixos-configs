pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:c63b71155541de52a9e60ba13fd10824a59f649812ca18701509b7b804a5253a";
  hash = "sha256-fqn15d22qW86RNBnu//tjsp304Qot5vv+06/XCC4X5Y=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
