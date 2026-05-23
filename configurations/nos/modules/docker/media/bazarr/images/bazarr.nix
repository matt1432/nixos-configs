pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:95f27692c3de6dbe130cd035d342d8138ec74ade7b62cfc52e11ae222c52c855";
  hash = "sha256-2DtJvGZ+6GbnsQQ4we0sBclMAhbTQCQpGGZiXw1iVew=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
