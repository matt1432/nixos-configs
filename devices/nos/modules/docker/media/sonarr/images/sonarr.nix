pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:879f5f35b05566f71296bad0f3704709103568a6b4f42f5959543f5322728723";
  sha256 = "0aq9pcqmqc5sq4g9c5wj8iw8gj1i9kja26bacg1vs2s8y8vhkpby";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
