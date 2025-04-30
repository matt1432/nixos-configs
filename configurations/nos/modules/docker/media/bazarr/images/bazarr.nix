pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:f17f0335c1b61aae73dd2b08477ead4ebc6df03f57badddb42a173e4637ee1ed";
  hash = "sha256-oBVmQY1/36HlNINGT6Q35mgTjGwA/zCXERZf8eqNcQg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
