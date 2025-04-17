pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:02ab7bbb1423d790d7fdf39b62851b4422243858e282738744930270bf2e2a99";
  hash = "sha256-kix0y5xsijlXGkK57gLQlvDjRR9s8a46HV3yVJ+yfAg=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
