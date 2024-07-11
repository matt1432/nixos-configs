pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:248a6da7dadeb57f90eacd5635ecc65e63d4c3646a6c94a362bb57cba1b314fa";
  sha256 = "03w9m0hsid9ppfyy8wmnccvmjh0m4h061yy1hwa4psijlx976xxp";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.108.0";
}
