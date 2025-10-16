pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "minio/minio";
  imageDigest = "sha256:14cea493d9a34af32f524e538b8346cf79f3321eff8e708c1e2960462bd8936e";
  hash = "sha256-luLrbbivL653bT7T74aT3sJwPQ6uAq0Rp7KYFMU/FDA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
