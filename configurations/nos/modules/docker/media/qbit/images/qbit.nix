pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:8bff8880f4e056c068ac6359de4cbcf44fb4811493cf15d83c1341fa05a515c0";
  hash = "sha256-Xw9bBMbF5a9Jg4U/nTz7wpOTgncOlnqFe2rdMN4UFLE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
