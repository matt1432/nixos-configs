pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:69ef02a36012a1b7c53b193da26398d4487dfe1def5ef6c0bb9b1a473e32d65e";
  hash = "sha256-D4s3ps3r5KAXvdIYqGo6PA25eOEK2PSBzTToyYrQHuc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
