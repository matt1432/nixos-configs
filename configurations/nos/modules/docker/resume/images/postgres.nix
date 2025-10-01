pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:9d3064c832a087fa9b2c03a18e178d137f82d3e0d51484853fb3f7040d13239a";
  hash = "sha256-yF8cwPRNFfJy+dCOfs6eFC9aV0e3buwbwFWrJcBmJLo=";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
