pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:ab91301778251f82a31bbfc87f0497376d59e84439d9a1ceff6a61d594d1e3d7";
  hash = "sha256-Zl3+QdgIhOk8JKawFScPPwMNQppGRrCGxS7gQizIexM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
