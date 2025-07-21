pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:5862232f7e0a11fce5495f68d2a45c55ee5430785dec00148e5e804a136b7fd4";
  hash = "sha256-hUjP9DFAjqumn4hJejObiR+2MbFjLgx/yDePOfQTHio=";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
