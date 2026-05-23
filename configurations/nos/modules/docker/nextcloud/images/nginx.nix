pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:5aca99593157f4ae539a5dec1092a0ad8762f8e2eb1789085a13a0f5622369f6";
  hash = "sha256-qQIcxN0P4m6W6VBYWIUKVwU5YWHDT0vi+H9TeqTXyy0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
