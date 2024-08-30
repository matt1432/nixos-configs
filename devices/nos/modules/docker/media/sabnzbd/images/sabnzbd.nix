pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:223197e9cbb70112244e44ba9660ba7ce1d2128771b8a03ad38e20f85c953583";
  sha256 = "1ix1q550gf3038vrvqbds2075lhlik3mwyjic6hw3arsqkdhqqls";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
