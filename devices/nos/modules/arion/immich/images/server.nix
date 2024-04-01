pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:d603fd34d587cbf0c99442bb44da395450157d5eb7dec40d2d1d16f2cfdb988b";
  sha256 = "16cn2qms315cka4jqrxyj23qnbl2rrkdilnmfwgqzqfz5mdah44l";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.100.0";
}
