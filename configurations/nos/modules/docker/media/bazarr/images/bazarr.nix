pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:a92ba81b9405942d0b5c01e2707ba8fb99ab059dd800d1dc0e8f52f62ddf74dd";
  hash = "sha256-ny9/R9sNVsKMdxWdF8lAeXutUZL3CcBgVjon/0IuktA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
