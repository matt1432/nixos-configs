pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:caf571b373f415ee673b22ae7b3d110e947305e18bdd89ad07106267f25a5e1a";
  hash = "sha256-HfGRSwysGXfoRH4LxkhyiplM7jO/hz2JnHAzYLTwLKk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
