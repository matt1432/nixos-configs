pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:b7ba431bf6f9b26cc86132798f3640964147a699cf23f026b74c6c05dbb1d60d";
  hash = "sha256-0sEP+pm56YrQTltdi9f+uG8RslfuPkcdHxRkAwbIYs0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
