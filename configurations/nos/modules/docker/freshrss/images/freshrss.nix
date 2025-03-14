pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "freshrss/freshrss";
  imageDigest = "sha256:bca4407f1f3ecb2e02bd57f704593c64f89bbf3fad53f03ebcf4baecb0122de6";
  hash = "sha256-aZQT5bBjfrAH93z3YV/203LrAdrItI0hPI+/dmvvOZU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
