pkgs:
pkgs.dockerTools.pullImage {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:edb8e2bab9cbca22e555638294db9b3657ffbb6e5d149a29d7ccdb243e3c71e0";
  sha256 = "1a8wp3p1zgviqi85lb4gp10wajagx6bqizfk524v42c49x1qpfpm";
  finalImageName = "quay.io/vaultwarden/server";
  finalImageTag = "latest";
}
