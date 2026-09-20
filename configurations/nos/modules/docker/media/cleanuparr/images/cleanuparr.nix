pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/cleanuparr/cleanuparr";
  imageDigest = "sha256:8136c3beda7aa217012657e0ee31f0473ff4ae7e54a156730ff04523987fa815";
  hash = "sha256-5AdjS+fEKU5ZvD+16tB6kF8u8Tn8D5DMx+AB/cbXhdc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
