pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:4538137bc5af902dece165f2bf73776d9cf4eafb6dd714670724af8f3eb77764";
  hash = "sha256-kqe6N3zInOqfa9d2Pnd3/FasyHFGZ+SSiltyZvC5QHM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
