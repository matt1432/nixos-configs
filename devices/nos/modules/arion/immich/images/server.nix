pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:b8b8fd71818be31bb934b93d146259ed88398fe3dbf01c88ca364c8f2992d422";
  sha256 = "0svj9psjhwvkajbfhg718xrv2xmg2whljasn563mravdmpzqfkc2";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.102.0";
}
