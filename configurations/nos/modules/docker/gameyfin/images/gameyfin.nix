pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "grimsi/gameyfin";
  imageDigest = "sha256:ddc99c9f7568f7640bb8d032f03786f0131756ea94964ebe8004176a493801ab";
  hash = "sha256-wSoaJ0DfiPjD4o4DWINjAZWW754CNYp6nUQYf6KY7ng=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
