pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:536036aeb2c740d1a660ccf143b58a8bd6222f09010258fdfc10a538af7bec78";
  hash = "sha256-IwtLeM/N1nz1sr2eZproqFc4v6vvOGdquL2ORrZggmI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
