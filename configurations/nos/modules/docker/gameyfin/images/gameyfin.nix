pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/gameyfin/gameyfin";
  imageDigest = "sha256:ddc99c9f7568f7640bb8d032f03786f0131756ea94964ebe8004176a493801ab";
  hash = "sha256-Tu62zhhxr/2I7RYRO2MPM9v4xbbfwDvuiWGVGzN0vJg=";
  finalImageName = imageName;
  finalImageTag = "2";
}
