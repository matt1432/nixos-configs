pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:d4cb094a7bdc2d825db7ae5ebfcd2415e3ca5ff78a4fb56a045f1074fa3ae5b4";
  hash = "sha256-PJthdPayVAUjD0nkgFt+8NOYSDxjVW46IHo9KrPAMvM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
