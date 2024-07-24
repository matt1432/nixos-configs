pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/flaresolverr/flaresolverr";
  imageDigest = "sha256:f104ee51e5124d83cf3be9b37480649355d223f7d8f9e453d0d5ef06c6e3b31b";
  sha256 = "1ixsv5rv39bp7y1w2p0zjz9ivl82s3kndr5r39krgyknhzxavazc";
  finalImageName = "ghcr.io/flaresolverr/flaresolverr";
  finalImageTag = "latest";
}
