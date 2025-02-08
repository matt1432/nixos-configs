pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "cyfershepard/jellystat";
  imageDigest = "sha256:cc634936b69260548715953c0a4fcfb2dde6f6daa8eed3a6d08d0dcf0a72b9ed";
  hash = "sha256-UZq435kIxakrwaStbe7LbQRwB0XRSzxYw9CVnctrku0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
