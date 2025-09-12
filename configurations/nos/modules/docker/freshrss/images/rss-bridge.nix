pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:3ba2d100e69a229338fc4eede38d64af23f9cd6e8043196d0a3abc9453de6253";
  hash = "sha256-sVL08qtnSs8oznztyQPfQjVXoOgiimbemRbf28gJFiY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
