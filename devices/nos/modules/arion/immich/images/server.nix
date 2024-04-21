pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:bce8c500bfd89f01af056460431c7b20cec16d08b07299fd530824f6d420b656";
  sha256 = "1k7igyic7iqn6rmw6lwbjgpw8aljsl0s5j320anbqhpczp5drn74";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.102.3";
}
