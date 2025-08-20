pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:33ec7e5e707f02df63b5dd9cc8aa7ccdef5777d54dcad9bb589ad8b2a12f68ce";
  hash = "sha256-KNC+9phumyJRTXkJPZnuYUBdahpdi3TUEaFOUgY1lPQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
