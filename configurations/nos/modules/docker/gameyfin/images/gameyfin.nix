pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/gameyfin/gameyfin";
  imageDigest = "sha256:bee6f65615abe6279fd90ea444df087e5efb1eb9098894ad960220d2f38c6998";
  hash = "sha256-NSzIY3fEjJoy3v3rnCWQR3z6psWWtZMT123Tobv0EoY=";
  finalImageName = imageName;
  finalImageTag = "2";
}
