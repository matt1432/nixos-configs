pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:7eb755fd9989f8554ed8f5332b931caf996826c51498400534c8c78d1c2f226f";
  hash = "sha256-laxqjdgkWVYrAHJ78tnC7VxshvV3oZJJ2hyoW0QsUhA=";
  finalImageName = imageName;
  finalImageTag = "release";
}
