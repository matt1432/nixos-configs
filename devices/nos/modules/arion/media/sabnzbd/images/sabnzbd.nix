pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:8ee3019ca921f6c46294f2e363453fa41875d309c7e68028a73f8169eb35a691";
  sha256 = "02cdw87rgbnc8iryx2x02ccgybb7ic70mgia6dvsgds8l4xwz2nf";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
