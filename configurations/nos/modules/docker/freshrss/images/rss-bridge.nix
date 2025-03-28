pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:0f7d2b00daf14e3eee4281a3bb0f90dc89e02dba6720445fadf02437ec27075a";
  hash = "sha256-wfVC5wTXhkmvIV+Z6895s7nkE4Z2YrGOrTXeKoeHdk4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
