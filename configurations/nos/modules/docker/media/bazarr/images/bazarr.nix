pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:7fa77912d9cc0573ca4efd9ac542aba4fd51eb6d331c3ad7aac7bc7fca48b929";
  hash = "sha256-wDG0TN9pl7KlQoLJKLERuyJfCnMUJkwWaxuM55I/b1M=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
