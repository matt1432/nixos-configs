pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:e00e87e0e7c24fdc992093756f120a6ab292790b6a637ff3641bf813091cd726";
  hash = "sha256-DRgYlCdy9Szi2S1QyRcRIZj01W7E4wmq2Devgog7NX4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
