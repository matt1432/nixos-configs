pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:fbd543c32b656bef73bf514765f053fe2c62b1e0d18b23cb773713fbf1249c55";
  sha256 = "09fzg270a7x1wr7sqwpxcajfldwmr0iv19h6bcrpj48bvyq3rm92";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}
