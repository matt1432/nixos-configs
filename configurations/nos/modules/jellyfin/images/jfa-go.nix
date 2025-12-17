pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:0b662139e594b76e3cda73c9cee986af2c6605d2a3def05ccd1220e5107a593f";
  hash = "sha256-C4hS56jUmOmAKLJmgUQ9HxFJWGCf2sItQKcsgaUZ63k=";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
