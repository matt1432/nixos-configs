pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:57a563126c0fd426346b02e5aa231ae9e5fd66f2248b36553207a0eca1403fde";
  hash = "sha256-GZA2ZIhDVPgXmJ831Ix16dYK9nGntckNpyS9Md7yrNU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
