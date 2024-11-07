pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:88684337f4e3ea6c47623e47c5c27f798ed0d24fbca3e08c8d04be7a2b8a5668";
  sha256 = "1r9jrbc9vqxnk6sh3k8c6k9c1c64498fk61nbvgasxhaf4l82cz1";
  finalImageName = imageName;
  finalImageTag = "latest";
}
