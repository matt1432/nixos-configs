pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:404d19a094ae9c1f8d87987cd2541893be4ee1ce90712048f3523bf9bcefd4dd";
  hash = "sha256-ymAt75wvtdYqKmf01KPt7LaqXox3dL4t/TjMSi1bMDw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
