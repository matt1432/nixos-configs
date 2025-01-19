pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:7a25facfb3e08c9f57cee1ffd995141de80587be1b038bba5fa8611c2355225a";
  hash = "sha256-UYsBnvw9PWZXXZAqVhJkAMZ2IkrTOqvkAYjiHoIbXuw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
