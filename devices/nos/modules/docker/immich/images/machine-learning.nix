pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:c0300d34fb275343c8e3b50796c9b10e6f33218e84c958386a218fbdceaeed65";
  sha256 = "083bwhkm9di3c3xz9yzp5hxmgm73wmlsqgjm11hjnwh3735zw54g";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.114.0";
}
