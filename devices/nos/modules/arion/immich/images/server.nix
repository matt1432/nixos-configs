pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:4421f65082d70e446284e887c48e8231fd768469387d12c484dc628001ffceba";
  sha256 = "18hmf2rskps8f5bdi8nihzfk73cfq5k3yrpigz6kl9nxl3vxam6f";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.98.1";
}
