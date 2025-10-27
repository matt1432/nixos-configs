pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:643220338204525524db787ff38a607261597f49d1f550694acdb3e908e2b43e";
  hash = "sha256-8TthA2uise5AVImxgNJE5OecEFFnGdNk7R4ia4F8yBc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
