pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:f2b26429893d4c4cb71941b7ee50b1bdecd9d5f9f9e02d5410615e9f4f7c8d95";
  hash = "sha256-vqu6mxmPTgTB1y6DrFfpMCszRlF46rtKpSeSEmhZtLM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
