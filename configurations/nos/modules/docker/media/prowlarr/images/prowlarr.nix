pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:c96b56d94d116a9f4de94bc23d3381689492e6c3cfb7435320e8d982e406f99a";
  hash = "sha256-QB9VJGtTJQ6q0iAR/WDTicve+5eH5XxXNUX+K2qXI20=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
