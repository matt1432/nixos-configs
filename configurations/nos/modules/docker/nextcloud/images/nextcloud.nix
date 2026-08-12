pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:f10fb7467a9ad56de6d4c43afedca15b79d83ee6f728a5510faa53b3c55c2232";
  hash = "sha256-nEOZRVDwBkdVmnsOTSRwY1ufBOEgWSABf87VtJXwAAI=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
