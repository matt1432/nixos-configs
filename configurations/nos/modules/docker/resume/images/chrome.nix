pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "chromedp/headless-shell";
  imageDigest = "sha256:88359186a9024c4de0b0245c7001e39d5609e0aa0dafab3a0914e9419f258e28";
  hash = "sha256-Mh7Qfd/Uoi92Ls59o7d++7NPD2Gk3zVsAGxr0vLW4Xc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
