pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:86c951e05bf56c93d95d397747fb8820ac76cc3bedb78f43abd83eedbe3666ae";
  hash = "sha256-cDAZ4WELD4GAzAu4+H/wUHZHMb8XDvxLbYPXbjOIXXE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
