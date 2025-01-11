pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:a7fb5bd7208bfd5915c2527cef57dd8b00bdf684b68e5c9ec4326f10b6cf94b3";
  hash = "sha256-jAY/vxGsOSoCQKuLqzkgpasdCg/tOD2rxhUQwHKzcXE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
