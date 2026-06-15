pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:29ee7bb30d804447dc9a91fd0d74322ae1dc3a4072cc6346f70a5ed6e783b565";
  hash = "sha256-AEQFWxgKb+n9Tx99P8xQM7bRTTQtr31Rw00ofhv/V4Y=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
