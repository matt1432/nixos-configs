pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:c52a1eacd797d94461b11336655595e2083524ecd2e513a8fb9d9d83ccbede94";
  sha256 = "1irnwqg8qibyigv6xwwsfgbhlfjs5ys93mrwws61c7hi21pisv5h";
  finalImageName = imageName;
  finalImageTag = "release";
}
