pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:9a8eec71f4a52411cc43edc7a50f33e9b6f62b5baca0dd95f0c6e7fd60f1a341";
  hash = "sha256-ilF0pXMx1IkcNLfbrA8Ge1iV9arerrci25qY1WBya3k=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
