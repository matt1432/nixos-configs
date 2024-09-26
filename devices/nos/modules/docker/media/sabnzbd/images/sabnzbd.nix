pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:51df466fb66b6a18d89597a3608bb2ab69ff8aff3131b5bec80e4ed7534b2b9f";
  sha256 = "0gjxg3bb12nlcx0vvmvwdrg4px512vyzx42g9pb8qfzdmj5zkxyk";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
