pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:481ed58f7da20c5eadea8ee3c003b112d8c0ac95813184730e98fc0fefc66bb0";
  sha256 = "02mhwl9106zdvj1iabwl9wl9rbgvfvdbwn653dj8cisqnail6z5l";
  finalImageName = "ghcr.io/fallenbagel/jellyseerr";
  finalImageTag = "develop";
}
