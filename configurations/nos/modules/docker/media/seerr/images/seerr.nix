pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/seerr-team/seerr";
  imageDigest = "sha256:b35ba0461c4a1033d117ac1e5968fd4cbe777899e4cbfbdeaf3d10a42a0eb7e9";
  hash = "sha256-vQvA1my9ktdowORDtcdO1jTb9pPsFhdhzmOfl5pM3xU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
