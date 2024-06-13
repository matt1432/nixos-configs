pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:ab89014bb120a092a67c3702b38a9c614e8d06fd6f62225edb8ce770f26fd08a";
  sha256 = "0vdqpa7l2a6jnb3zr4l8jqzf4cgzmyhmljn7qbmslji96s20158z";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
