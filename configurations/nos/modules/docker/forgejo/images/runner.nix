pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "data.forgejo.org/forgejo/runner";
  imageDigest = "sha256:d708348726d2358236ada4f134c721e7f9925c511d807ff9332a12c68e55a323";
  hash = "sha256-dX7BVM/UCDELwUn/WELJs8BgvWwXGnDWu4GrvkREJPM=";
  finalImageName = imageName;
  finalImageTag = "12";
}
