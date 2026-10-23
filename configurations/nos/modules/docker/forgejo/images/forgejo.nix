pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:e2c34a699543ca8a00217ee9ab2bea5feedc98bd6d0ea95ec287d3b7ae1355c6";
  hash = "sha256-RQdYJaFxDfoxs9KXgUrtfqJE8dCXFruWiup43AIBy94=";
  finalImageName = imageName;
  finalImageTag = "16";
}
