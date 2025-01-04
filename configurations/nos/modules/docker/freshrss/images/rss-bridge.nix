pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:c72b284fe82f6c2bf676d55a3e5354e53108095a8d698ac1c9211b5b854c79d4";
  hash = "sha256-L80CePRKz+zFCAPinQKSgM6m3M0ADAbkhawfL7Yzh8w=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
