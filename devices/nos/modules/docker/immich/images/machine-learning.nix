pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:66f13f7fb1af555f9f1767c3dd5d404b7e5f486a272dc73af9e6480f541463dc";
  sha256 = "sha256-viIEwdXF60/1aX1JB1QG69yDqgWIXIAHvrgjlrX2jjU=";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "release";
}
