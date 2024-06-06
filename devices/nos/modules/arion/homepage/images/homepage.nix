pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/gethomepage/homepage";
  imageDigest = "sha256:5356c97b51e3cc817bed93612b4e57b39d28048ab9e4e3b346e827160cf0923e";
  sha256 = "02nak2ag321w65kib9j3mpbdqaa415lssi7way3vvsal4xddvb1i";
  finalImageName = "ghcr.io/gethomepage/homepage";
  finalImageTag = "latest";
}
