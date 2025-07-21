pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:f4c16d0a40959cb83652cb4ac8cdad3273b68fee52dff64b5bf42db95c5c3baa";
  hash = "sha256-XlU9FwGSRNcfDaAKCW+ElGk2vn8j3jBAFbHbNcxViBw=";
  finalImageName = imageName;
  finalImageTag = "12";
}
