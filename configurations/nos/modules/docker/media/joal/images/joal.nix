pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "anthonyraymond/joal";
  imageDigest = "sha256:fc942567c5649b29377e50aa0ca934e4750534d02b4ecf5a0eda3984630f35d7";
  sha256 = "03wqqhpsjcdgr4q3n9vqyxb59324mxnwn8jn6kj2kb6zq8bz3qrj";
  finalImageName = imageName;
  finalImageTag = "latest";
}
