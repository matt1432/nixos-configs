pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:2e17e15855907ece0d5b3a7bf625b12f6d987a5854fa71d888641acae28b0323";
  hash = "sha256-nmcQDmcZNkOOk+5Bw4TJQvc0bob5PTgFt9AKfXbiF8E=";
  finalImageName = imageName;
  finalImageTag = "release";
}
