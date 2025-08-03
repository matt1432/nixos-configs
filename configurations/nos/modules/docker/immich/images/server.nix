pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:e517f806457057d44695152a0af2dfa094225a7d85eb37f518925e68864c658d";
  hash = "sha256-bGL3u2IDxmregj9TRKphZfGogchpOGe1NLvBROtBjIE=";
  finalImageName = imageName;
  finalImageTag = "release";
}
