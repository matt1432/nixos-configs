pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:0b3f344388bd7bed4f2f770058de795e76447e4a481b83c8d5f8fed489371fde";
  hash = "sha256-jKHnDHwcBI9jPIkkF7j8vhUWx3fkuKyxz7WQ8MYMMhE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
