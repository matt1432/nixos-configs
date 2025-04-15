pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:bada251086dbe3945b1fe79e1bbdd6cbf51eb4ae4ab115617928ebeabe38699d";
  hash = "sha256-tHESEgImbH9FXnUqNU8RO0TWHGuVKDbPLv0/QEXtDY8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
