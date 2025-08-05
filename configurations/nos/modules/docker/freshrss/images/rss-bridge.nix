pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:a52a2193c8247c11efb0d88f9367b17cdd97b33e1dfc1fbb52c8e159f24561fe";
  hash = "sha256-3LO3IGPMNI1hgcwTEsIuzEGdoOvx3+tq1W/whrCpdy4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
