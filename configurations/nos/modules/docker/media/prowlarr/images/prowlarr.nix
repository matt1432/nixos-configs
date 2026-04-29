pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:b4204e18666179472225935b443a99cf6c66dcb7bbc2d35034427a3851f13135";
  hash = "sha256-Lh4tow7ynI2BfUu5AEmhkpLTcFv4z/L2aKx97Qw8gKc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
