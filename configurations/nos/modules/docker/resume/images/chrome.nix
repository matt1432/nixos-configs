pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/browserless/chromium";
  imageDigest = "sha256:57a1edb1f76e56cf1f128a2c379381df9d937e643c2cf562d76463b0280c24c4";
  hash = "sha256-nqbaeq/JBWRhCHai9QwYe4Afq+u6eh4MEapDxUwCuio=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
