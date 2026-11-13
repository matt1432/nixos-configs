pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:673dc4609a5672bc8e46069c86ffcea283a86b48d34a6c93d8da8c24a1b87571";
  hash = "sha256-zrzTpSuhwwGzDRFYynAP++hCbJEnWGeC2wjCQQGEFrM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
