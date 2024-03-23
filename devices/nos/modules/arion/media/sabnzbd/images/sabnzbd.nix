pkgs:
pkgs.dockerTools.pullImage {
  imageName = "lscr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:0252a6a90048ec8efdbb2fa20d250ec38bb9446a9d8bd25b3c4921895fa15cf8";
  sha256 = "1r8ki2kcggp4zkhp7l3dv74cqcy1x6rrl54r96qx80mk8cpg0zia";
  finalImageName = "lscr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
