pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:b0a22ca87496019f495ed5ce89df08da237e0987d389376b435b2226a8c29463";
  sha256 = "001nj0dsqzb3lhvjrm88wv3cmm5yx8wldw3i7kq1vs80gi4ckhs1";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.101.0";
}
