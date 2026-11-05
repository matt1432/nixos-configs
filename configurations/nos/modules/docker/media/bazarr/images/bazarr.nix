pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:7ef0e58216900dbce30b123e0eb65f5cb30e36f126de9474acdd2022fb069c54";
  hash = "sha256-PBBA2CMOrNKDbjtRY/N+wAsRT0Bia++gc2DdC5nqthc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
