pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:45cc665c3c48d1bad171482e2e2f37085ad9a66371550efea434633cb1d906b2";
  sha256 = "097npi42i1bkr7ipp1gyip0z8q3dypw6wmc14whzqp81kicmvxfl";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
