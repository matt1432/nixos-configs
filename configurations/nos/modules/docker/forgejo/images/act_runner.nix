pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:fdbd660f3d3dc0fa9301df7991435b3f16e6aa3a0dffd9d929735d57d5458567";
  hash = "sha256-z76+ggtpm6P+RtqDpGItjmyul8EfpFgH/hCkIp/vtE0=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
