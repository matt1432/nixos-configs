pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:27ceb1867f5501818c86188c62924bbfd3024d8f74395cd66d6a302b01d1b2cd";
  sha256 = "1rj894f7n82ajhfm93yjjv7jwxi5m07ahxz6wrbfmkw8rfmldj1i";
  finalImageName = imageName;
  finalImageTag = "release";
}
