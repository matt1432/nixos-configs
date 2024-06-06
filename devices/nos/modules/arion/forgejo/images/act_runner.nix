pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:01b41f715ae9d5685dcefead4e9ec7d5a35254853327b174adc6a229ae63f56a";
  sha256 = "0y6vnc1n3h6759k6z500kjrfpgankmv5jzq6rc9k2ll0r54ygyhi";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
