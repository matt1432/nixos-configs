pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:a00b6a597a3832a1814cde0ef60abc55c94644f3f80902c3432f6af6de8d4a96";
  hash = "sha256-CVa823Vuv0LCwbCRDqTWnxj3Pwsdg0iimY6FsUxY48c=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
