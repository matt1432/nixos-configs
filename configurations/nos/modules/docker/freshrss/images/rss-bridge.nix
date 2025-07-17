pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:c9d512b7976052e9972188f987bda2b413cdec0b3974930f4e025b47185c8867";
  hash = "sha256-zMuS7b8zhhKMZBzjT4kpYArOozuhehDYS4kurWO6kkU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
