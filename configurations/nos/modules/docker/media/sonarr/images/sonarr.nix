pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:02bc962946fef994e67a38152446df25c10a52f8583aefeeb6467f9dd44cab99";
  hash = "sha256-mWh31gkFgGE52Ztfww4sz9nBtPYveNLMboqQoI/gmb8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
