pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:1a20dc211cac70890d4f0a61b6ef06e0d47dca91ace64b6a9af9b49de2c8f627";
  hash = "sha256-N/OBEhOsZ5McDTrPBespfCazPeXGP7QLcXkXHZiJ8Xc=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
