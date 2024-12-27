pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:0068f9fa55cdf8b72b831b8fd56e9e94cf1de969cfa1f58f7ba11ee3619eaf65";
  hash = "sha256-Mu5XIeUB8B/FiBnQJeW3NSG5ifV4x8j7gkz6+pbFJ08=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
