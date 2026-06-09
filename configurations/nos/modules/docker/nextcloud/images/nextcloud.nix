pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:71e95c52e19afb32f1b8d533673e2e46c1d8a9f14b94fd44188c2cf3016d76de";
  hash = "sha256-uSKYoDrqEtZ+EX5LScIN7KwHRDrfnTH4njDlLBC2h9g=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
