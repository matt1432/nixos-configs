pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:ca00e6d11fe0dc3a466c741cc8906163a2461d7deb1ae46bc2fabbdcb21c1b7b";
  hash = "sha256-AGcm48Iv1rCxYQDYuw1066edG9lozHwbfgnp0fNbUuQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
