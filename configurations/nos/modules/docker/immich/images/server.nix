pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:040b2fed8f7f6b7405f9b4b26348b4656355e4d4ed0852b8e966d453dd6635cc";
  hash = "sha256-6Tehwcg334OP3Qif8GBZHVZ1HgVnYM/LfZ7E7uXCP08=";
  finalImageName = imageName;
  finalImageTag = "release";
}
