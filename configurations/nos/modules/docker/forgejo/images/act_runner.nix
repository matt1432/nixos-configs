pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:23678d1201b7b2a9b3960b20ff0fb658b5441774afe04ff615e572257c86fcf8";
  hash = "sha256-LK9diQGdecLQyTexPXyZEVv/NWyz789jrfkCh8gCR/Q=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
