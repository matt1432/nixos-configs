pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:efb3cde962015fcc036b2ea625242248611943b27212ebf4392841fb30fad055";
  hash = "sha256-qQYUGMGabnmkZrHrWPhSWJZgKYvDeYey7LSB0CwQHlc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
