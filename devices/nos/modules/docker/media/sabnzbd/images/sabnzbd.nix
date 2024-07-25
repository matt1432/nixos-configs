pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:d6a2a967d47b495c5342bc23de76d35eeb2f3ceb53c7be51885ad25f95dffe9b";
  sha256 = "1irwak666zz43lsfrn0zijcakqgwmzdf5ddw2gy4csn9ydsrpfhh";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
