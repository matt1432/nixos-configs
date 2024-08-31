pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:9d1c9ab40f3171f1dc06d5c6bc32541ff4b0835c1d217ff5cc61c85e26d2452f";
  sha256 = "00k64lzmlqpv6nc9mfm04q0qwxvhnhg0a6zpwqblgqsqv39xql63";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.113.0";
}
