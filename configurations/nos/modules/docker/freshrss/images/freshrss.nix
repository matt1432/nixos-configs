pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "freshrss/freshrss";
  imageDigest = "sha256:9a56be99f3927cc8fab4c6bbd5723ae098824792d4d98a84007a95eb64e8f905";
  hash = "sha256-TZzjMNEKwU4g5VlC0Ph8y9u8+7ncbPQRMafI466o0Wc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
