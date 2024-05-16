pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:361ccf9363a43864cd30fbf598874b35294c585df778d28ae8858da7df32f564";
  sha256 = "0b8yxpahzgsfkmqarakhv3ps9ky3vq1d7wpxa7ik6l4h96wa6yfy";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
