pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:445df84770a5a99d141a79700f2806313bf9569ffa08a71f055b28702859a981";
  hash = "sha256-urq/le1Y8ahVyTRcOdzGZXnq3hl6L+Zffb6YdH3eZSo=";
  finalImageName = imageName;
  finalImageTag = "14";
}
