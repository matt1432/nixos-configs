pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:80a85b13a8e201be8ecf5a9be900e2917afc2985784c61dc23719936ea2defc9";
  sha256 = "1cpkc06hnzws2w03dmybap1brpfb74ml8jv3aqhnxgx6v8v39adc";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
