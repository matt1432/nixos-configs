pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:35f48abb3e976fcf077fae756866c582e4a90f8b24810ae4067b3558f7cdbbdf";
  hash = "sha256-23mB6m3vUyAxgdc4ZRLT3JTDaziuSKRYzfS4v5x9XHs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
