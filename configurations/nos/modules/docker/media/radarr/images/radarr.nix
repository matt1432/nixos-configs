pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:07a474b61394553e047ad43a1a78c1047fc99be0144c509dd91e3877f402ebcb";
  hash = "sha256-qh8D6w1y7ZYm/3n5GC5ih9HHJutQXg13+twvv+mgL3I=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
