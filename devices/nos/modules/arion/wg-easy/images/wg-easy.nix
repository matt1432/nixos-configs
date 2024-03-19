pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/wg-easy/wg-easy";
  imageDigest = "sha256:daa94b77901bdef3cb10151416c095e64cf66a6539fa8f748c09812b60b97f49";
  sha256 = "02880zh6fdmjlyi9nrvz1vzj4qa5642079xyzpbx3c1rplg033md";
  finalImageName = "ghcr.io/wg-easy/wg-easy";
  finalImageTag = "latest";
}
