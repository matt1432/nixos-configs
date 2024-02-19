pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:a3c612c548d5f547a31d001d97f661d7acd4a0ae354de76a70e45162d2b81014";
  sha256 = "1ij5x6lw80qwsjv8vb0nlc86kj0blss3gn34md8fgrz2rqjxr5nz";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "release";
}
