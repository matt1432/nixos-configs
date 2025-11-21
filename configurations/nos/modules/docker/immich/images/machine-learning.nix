pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:379e31b8c75107b0af8141904baa8cc933d7454b88fdb204265ef11749d7d908";
  hash = "sha256-kBGPR0JQnjfKhFK0U+pn4j5utvNf1dP/XxflH8qOZ4U=";
  finalImageName = imageName;
  finalImageTag = "release";
}
