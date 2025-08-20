pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:1a90192952c30f9420994b2e2171083ea8cae100357de5e9eb25890efa90a6ce";
  hash = "sha256-3W2WEW60BTtgN4SGzabxx+7O5tTjn8WO0Pv5BpCUBaA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
