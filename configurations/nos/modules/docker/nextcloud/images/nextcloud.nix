pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:17b6397dc0431f69e983f62a3e94aafb3b1f1c2ce4fc7bd6e9435251fa3413f3";
  hash = "sha256-CIvM8MRP7N3lpNZWaCf/0D7fSHsJwe6bF4/togMaiRc=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
