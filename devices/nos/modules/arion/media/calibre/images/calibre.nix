pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:09305d4225f22dc60f8539b158d652b3fde1bf999adeaac387588b8e28b50ca7";
  sha256 = "0nphvq1a5sbc70pis12hvapfqpgywq14h769jhgijvzqrfq1n3kc";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}
