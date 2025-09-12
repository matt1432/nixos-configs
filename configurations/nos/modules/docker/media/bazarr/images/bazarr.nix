pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:fed1656839bf8d916d6e7d0586c465ee7594cd503e6165c202ec782f25ea3029";
  hash = "sha256-cZDxiYrkRzHSlQP/4XQPITvGdeCSEAzURYbrsuHpx8U=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
