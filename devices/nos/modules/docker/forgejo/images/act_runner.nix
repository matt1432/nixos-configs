pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:4b6c8d7b73c597b70b6d675ad8bb75b1ad0cdd686fabd51a50f89baa2e9c27e8";
  sha256 = "0l7zwax4ayn0f3s72n6r51shmz63q8r5fjpyk4nv3nlj6hv6mk3l";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
