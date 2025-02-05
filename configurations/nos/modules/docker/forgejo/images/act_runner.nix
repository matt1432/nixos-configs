pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:8ae2791e150cf9d5378e14f7345b3f3ac46c6f16903d9a8338ffcea19e0f060e";
  hash = "sha256-q8UD4M1nrxCTaJo+3sq29dagYC2nhyXSNfm8xuNeCZI=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
