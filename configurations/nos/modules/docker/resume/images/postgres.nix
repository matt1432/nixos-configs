pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:c2d42a104eb6b37b286a2d9c5cf83f349de4d6516d513d00a2bd9610e2c2e5e4";
  hash = "sha256-Ad7y0IC+wj5XNNvqp7rJ6x3qcGroOEakiwlw/+WxcdM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
