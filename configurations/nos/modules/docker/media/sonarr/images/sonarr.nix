pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:0b5c4803f92456fb9b65bae8375716ea120b4ea17b3cced7da32b63f0085782b";
  hash = "sha256-gxDJ/iAQZrPcclyabSs47GSXtVRVb7aBThL2e3uJR9o=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
