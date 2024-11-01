pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:5ae714b1a941a38471c2cc381ec407f93b3d7823c5a77a9a651502036b70ad69";
  sha256 = "1bn8pz0739b6zl4f379qm7xqws2qdd8jbxsapwv49b72k533lfkm";
  finalImageName = imageName;
  finalImageTag = "latest";
}
