pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:67039e2dc98163bfdff8c3c1fbb79f75649c8f28b447f5308fcf762a5572f19c";
  hash = "sha256-CqZ4PhFyV+ujRDILYYmf5ZPcT4SU1JJ1cmauYXjuWoM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
