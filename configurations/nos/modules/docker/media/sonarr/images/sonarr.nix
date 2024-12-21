pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:b466acde22d18859336e790af23c0b56d9dbb7199935b226b3139bf416fe7e1c";
  hash = "sha256-WdfpfL2BlQWBjSAHNgo53kXVAOMa42BnITIYjPcCPZw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
