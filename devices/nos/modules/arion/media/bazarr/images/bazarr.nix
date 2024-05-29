pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:9ede46a9e9966ef88ec5f71970258bd53efa8decce1f663f477d4c397bc09b3d";
  sha256 = "0x4cdhs26y8hcxzwi1wkf1b877aqr5i1cggdcapc4rynfw4c8zrb";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
