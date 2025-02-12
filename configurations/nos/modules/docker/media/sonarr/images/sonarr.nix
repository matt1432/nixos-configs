pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:28d9dcbc846aed74bd47dc90305e016183443ddc3dfa3e8bcac268fc653a6e5e";
  hash = "sha256-NeiEECnipGUCR2qBNi23p2KZfqQ0NExPrA6e+46MsTA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
