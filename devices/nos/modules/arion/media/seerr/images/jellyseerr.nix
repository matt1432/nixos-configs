pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:155cec4b7b6726dec1c5721fa1a7e76888768dc464c6f05f9257ae709267377e";
  sha256 = "1fk46v2vg1qz5sz30c9h2j44c4hk2bljl9z8wl121v4gs28lcvah";
  finalImageName = "ghcr.io/fallenbagel/jellyseerr";
  finalImageTag = "develop";
}
