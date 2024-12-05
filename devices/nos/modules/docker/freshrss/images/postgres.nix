pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:19afc4af194bd5a58f3d86924fb1ab42b1950ffdc70b145996f1919ef6b03222";
  sha256 = "1ik3l78j3qr6ss8ryff99zfl4abirp7ygd42h6yhdj5j41cidic9";
  finalImageName = imageName;
  finalImageTag = "14";
}
