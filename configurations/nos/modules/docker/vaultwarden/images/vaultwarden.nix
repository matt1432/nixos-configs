pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:c4f6056fe0c288a052a223cecd263a90d1dda1a0177bb5b054a363a6c7b211d9";
  hash = "sha256-rOwvX04tC5d4fs8bmBNfK1nKoNsKhPQqxjyrr2nK1WU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
