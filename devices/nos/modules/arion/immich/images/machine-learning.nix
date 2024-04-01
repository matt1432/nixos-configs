pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:612e8856ad92f5915ececd5a67b76b7218f0fe4e41c72fcf1675bee76802294b";
  sha256 = "112c1ab5872xrz9kshyvifx078kb0g5rsq21kzsvk5zkavk1gddz";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.100.0";
}
