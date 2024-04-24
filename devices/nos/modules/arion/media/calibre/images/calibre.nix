pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:b9396864085793c57ae2ece29246839ad4eb29e8f007a8d8969c6eb98ff8e850";
  sha256 = "02rgpaf1zj7yp6ysy46srcyglhwpbrgi9gg0bq9sqigz5nc26qr3";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}
