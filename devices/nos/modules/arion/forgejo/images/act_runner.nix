pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:c896b5608f1e258c62a7f9c14f126695490d4720f979777a6a1f2e389ddc5216";
  sha256 = "16k0qq2r2iwx4mk165lp68isrfb9bh28vzhvpfgcb5cjyl8c2d0w";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
