pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:d991eb07331e9d1f9cec7bc0f9523fd5d51aee3b223d997e0e66206361952056";
  hash = "sha256-KTin9AZjUp7HGZfhtfte000vHguqtHKiBy6ChUPMux0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
