pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:60d6d3b7090c664b76adabd00c06674e25c5a91419e374bff4e7cf2ee5dd920a";
  sha256 = "0pfd16w35xhrlg9c1ch66j1z0gzf11nzmlsgxjsswwa0ycndyddg";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "release";
}
