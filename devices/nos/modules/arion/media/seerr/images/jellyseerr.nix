pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:08691ea0069c30e106048199d65af0df3aecb5baa17c682b98fa4d73f41de43b";
  sha256 = "1kch5dn3idrv6ci0dq95f09lc60s7rrfnwyz9dcpd7vi56kxh5w3";
  finalImageName = "ghcr.io/fallenbagel/jellyseerr";
  finalImageTag = "develop";
}
