pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:d71334888c4f788945b126cee2015099088b26dc5e2c48fb71516cfaf175790f";
  hash = "sha256-JuvOK45VABv+jkLux1KgS6BbLx8B/WdgTRj311Y+XdY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
