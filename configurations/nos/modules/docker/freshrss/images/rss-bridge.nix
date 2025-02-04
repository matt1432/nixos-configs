pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:035d245d5f4e541451ce737d994c51d69506e50759f9e3bc6f2491668caed1f6";
  hash = "sha256-TZXKlpjSnj1Dl8CvsS7pGW3rCrVlPqfNypor7bdSQyI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
