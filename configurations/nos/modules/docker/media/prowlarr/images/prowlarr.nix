pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:608935c38763920b25622a3d404bb14ea08fcaa7c2a9b1c93ce9bac61ad4b11d";
  hash = "sha256-t2rrP7jfN04UkcXfIZTEHG9I5V65/wygCv7v4gN5NmI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
