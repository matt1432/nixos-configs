pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:275467ba17d990bbc6301dec3cc76b042969836749de39067818759d0f3b407f";
  sha256 = "1kxzyicqj885n5pjwa7jwkadb41r4xwfzbvcgwyb9gs78c4mzc1q";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
