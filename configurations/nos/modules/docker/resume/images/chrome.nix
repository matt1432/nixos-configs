pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "chromedp/headless-shell";
  imageDigest = "sha256:f76fce2964611eb1e25b90d906727884db12a8918a6d85a0df2619a9ef845c7c";
  hash = "sha256-y1Uv/L014nTCHjGW6iXyXpv+tjwihAENt86aROBRU10=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
