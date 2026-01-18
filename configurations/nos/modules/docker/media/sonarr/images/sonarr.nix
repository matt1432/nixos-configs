pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:02b4d538d351d6e35882a021c08e8600fe95d28860fb1dd724b597166e7221ca";
  hash = "sha256-WOjU5prN9KLSK1DrlTjKxvSwKvaQ/QOwKH8geszRbis=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
