pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:1881968aff6f7cdcc4b888c00a11f4ce241ad7ec957e0cb4a9e19e93a3ff87ea";
  hash = "sha256-UthdPnWnq4zurGGE9uwpjn1yrA3K5Rp/8kqvUK8CWjE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
