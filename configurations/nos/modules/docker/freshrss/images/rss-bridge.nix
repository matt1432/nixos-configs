pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:606896116558c57e3d381dec6874457f7a69216103d77c78b5bd38b92b251902";
  hash = "sha256-l8h8so118/00Q0463Yaby0GkB9J8xGOONyiBXMTehEY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
