pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:1daaf09ba61066184aad6e4f524b13e20f8884cb2030c314438e34cce9358b2c";
  hash = "sha256-V6fUT/d5sp7LjJzYuwea+UC1xzR/x8ftbnB5f5P1CqA=";
  finalImageName = imageName;
  finalImageTag = "release";
}
