pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:203a0854738be101bfdada825ac3cbf95e5681bc849757b6bc199e4cfae98faa";
  hash = "sha256-GZsHQ+AT0cpOGPRZeptrwcpM4z6BrxQ0fR4qcFD9UdM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
