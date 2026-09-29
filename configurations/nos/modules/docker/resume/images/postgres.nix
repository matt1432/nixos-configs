pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:5a5a84b19854a9ffaa54082c166ff4ec27473a361e496e5ea167f298f2da9722";
  hash = "sha256-cDAZ4WELD4GAzAu4+H/wUHZHMb8XDvxLbYPXbjOIXXE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
