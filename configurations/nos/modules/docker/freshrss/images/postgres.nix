pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:3bd32ecc31b2329385573ab3c631317362deb795f05dcee90bda5f3b1e79ea56";
  hash = "sha256-urq/le1Y8ahVyTRcOdzGZXnq3hl6L+Zffb6YdH3eZSo=";
  finalImageName = imageName;
  finalImageTag = "14";
}
