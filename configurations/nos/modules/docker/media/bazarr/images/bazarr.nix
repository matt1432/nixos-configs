pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:001875e61839c8a50743f0bc0fa4da2a55ed8a038b9b5ed0dd2c663dd3d0bfc7";
  hash = "sha256-wes4HLLmv/QUFkrjTyz/eCPEjMEj0wF9MFOnarBb3rg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
