pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:0c4fb2cfbe53f9e92767c5e40d36433c32e4080c1586ac35a45a0808c59067c6";
  hash = "sha256-b4Jt3xrK+JUAP0Rg6na2r55lBxlhWnDEfVsRzKAdbk4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
