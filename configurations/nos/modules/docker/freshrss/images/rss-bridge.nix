pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:8ee528a5bfbb1a45423854ab8898da5c70bc002043c48023c9a2a07352f9a23d";
  hash = "sha256-xCcj/5v236Q83rOon3Tbet5ZM8QoyMhUB9ZbMlIdcOw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
