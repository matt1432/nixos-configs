pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:e82b4c83bd453916c38ba7a9df8e7d324d4b696998ac815ed58c93b94b09adc0";
  sha256 = "0vk8vyqcaplbwp7xm94g91vspbfiwq4k3pp0n1h5jq33qjks1svb";
  finalImageName = "ghcr.io/fallenbagel/jellyseerr";
  finalImageTag = "develop";
}
