pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:808e8dc05c97d7a9aa5c7662973ce3f064a1d3f53351f220037d4d313a00e423";
  sha256 = "11z9yg3lsf7fcss9j7wl3937wvfsshvfiv6sg1anxh6g5ingihc1";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
