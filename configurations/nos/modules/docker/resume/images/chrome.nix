pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "chromedp/headless-shell";
  imageDigest = "sha256:3da74b0945e4f80f00f0310bcda9f76cee283539ebd200a053a7bebf3de89423";
  hash = "sha256-QAd1uL0hBvUJUN8ls7QHRei+UlrsaARwIjtPKSsx2nw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
