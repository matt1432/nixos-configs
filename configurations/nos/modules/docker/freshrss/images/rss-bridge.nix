pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:4115e5d74af0ff37e5b993ae736a070737c478978701853ddb1431b71839ab49";
  hash = "sha256-ibJT7GcH1NBac5Suurk4jx2+dhdtTDXZsMFwcBsNWWQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
