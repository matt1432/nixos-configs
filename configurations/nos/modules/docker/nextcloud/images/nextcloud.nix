pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:bb073483d2533fda7360a56845d0c2f2a3dc7a00cb75b9b360d97060052ece0d";
  hash = "sha256-4ZgxeH0N2kOrSWB0yll0uFWo7yFhrkn78vkx1ugP7JY=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
