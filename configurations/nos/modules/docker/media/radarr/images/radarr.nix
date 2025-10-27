pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:c984533510abe0219a70e80d15bd0d212b7df21baa0913759c4ce6cc9092240b";
  hash = "sha256-+j3cELGw3YtClV+AXCIs3++mzdiS2niSq3uetgSbm/M=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
