pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:02ee316a6cd158706cd15480f44bc4db39ac0f5ab52b76d596083583e7416f7f";
  sha256 = "0r0qriz01dhd4w56dixlnn71qmcx88r9xk90zp1fpwa5qm9464by";
  finalImageName = imageName;
  finalImageTag = "latest";
}
