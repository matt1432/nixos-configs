pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:79053c07400eec909d04ac97db760c30bf61471ec37465a50f126a3c825a92bc";
  sha256 = "0dh2vm963xwci4fpkpc1qpkhh5w80dajcm1n9pcrc1nqd0gnsp7f";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
