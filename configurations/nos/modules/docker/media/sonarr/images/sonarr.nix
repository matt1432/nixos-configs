pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:fbe67c25693dc5f3de220c5691f374576ae265df782c16918cc071b630490bd7";
  hash = "sha256-m4Jk4JhBJJloh4/GMZn63VzxZNBiAyCioEuVo3k0IoQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
