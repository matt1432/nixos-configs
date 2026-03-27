pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:9a631194c0dee21c85b5bff59e23610e1ae2f54594e922973949d271102e585e";
  hash = "sha256-Qvk8VJ9l5iqwp8PoT6J8YOcYD45Madoku46vYxR+Iaw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
