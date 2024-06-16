pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre-web";
  imageDigest = "sha256:a84c0bb4db5d6160fda447a99efd905fa19baac41b83e4490e3116810de74a34";
  sha256 = "0gjgad210k5kdczk475vmczngaxpzdd43bs9p7l5d7612vrllaf8";
  finalImageName = "ghcr.io/linuxserver/calibre-web";
  finalImageTag = "latest";
}
