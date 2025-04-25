pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:cc04fd226d3418e493c015eb9ad66857066a4ddf024d7214ab2b39712e19e74c";
  hash = "sha256-QAXrP+EhEoS1IfvumVinNzqEEYKPdKRHY0oHv0xX55M=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
