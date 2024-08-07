pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre-web";
  imageDigest = "sha256:ff7e870dec503f5bd02c5a528ba1f96617900cb4853ef05176bfbc278b5d263d";
  sha256 = "00g07x609rf9wdipxw260jmc3y2wkhawgzmlqsk9h60jbhxpck57";
  finalImageName = "ghcr.io/linuxserver/calibre-web";
  finalImageTag = "latest";
}
