pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:8e031d8dfa73601ff60696a4952b6c30a00018a1a4bc32f5b2a8bad109e09857";
  hash = "sha256-PzY9zwTLe+ga9JsZNI1knKylYw+sk89eDruSDBrqyfk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
