pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:a5074487380d4e686036ce61ed6f2d363939ae9a0c40123d1a9e3bb3a5f344b4";
  hash = "sha256-SwghBI8ZljN4axL7KKBldgY68R6/xJdNDe2iKotHgiE=";
  finalImageName = imageName;
  finalImageTag = "16-alpine";
}
