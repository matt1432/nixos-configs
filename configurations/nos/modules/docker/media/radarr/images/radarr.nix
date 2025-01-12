pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:dce7e81d08da67cf44437c7213d19faeef1323aa839712fbb53d1253ef94f93f";
  hash = "sha256-ofd2SBBeWZ1n9igIq0wp3G4L1tt8UMIVvhtt35pVl3I=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
