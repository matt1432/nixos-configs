pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/flaresolverr/flaresolverr";
  imageDigest = "sha256:c80ae007ce2ccdcd217a12426e4f039ef763ff90738c808d38810c3e59323767";
  hash = "sha256-jiwgI4zn1/8NdFbmmuf5CUeVWeDZagavYyDdp0emTik=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
