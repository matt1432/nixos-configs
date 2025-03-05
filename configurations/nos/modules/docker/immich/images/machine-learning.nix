pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:072b5eec074476726c38994ca80edc8d19e14859d49b0f1b6aaa04b0ce415f0c";
  hash = "sha256-Q6JdDAeNJs+BlZlRse+fIpUXpo6wQCWpNcCHpzPYoo8=";
  finalImageName = imageName;
  finalImageTag = "release";
}
