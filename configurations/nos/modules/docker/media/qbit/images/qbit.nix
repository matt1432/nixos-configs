pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:1fa2f9692501f27ce51c4fffd771d63ec38f1163cb648941c324344b7c5a3915";
  hash = "sha256-rAr7ZzjV5+F3smG0lTto4788zGlfrBX9aXs09Si0yrU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
