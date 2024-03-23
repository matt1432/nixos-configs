pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:aa8607f7674b53c89cfd6cb0d8939c464ce96e554bb26982345aeea5fbd7ffcf";
  sha256 = "018p26ni5db87mq0mcm5bg7q8zphaskfqiz6zrg5yb2ir3zplr9b";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
