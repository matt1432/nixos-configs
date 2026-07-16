pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:a698d240380a51147281b62c2ad9daff51ae29c781d6d783c0adfd8e48ef4b1e";
  hash = "sha256-CUDs/KAru/E37zGpPPWb43DGn5xfYj/67vSQlznBVWM=";
  finalImageName = imageName;
  finalImageTag = "14";
}
