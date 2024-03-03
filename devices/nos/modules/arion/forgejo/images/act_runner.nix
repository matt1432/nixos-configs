pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:9b32f76a8c5fe17e5591e6af63c01d578f3a16b56334e8d91e4c1719ad84eae7";
  sha256 = "1qrrnw4mah30y5blikhlwnymfs29zf08mqx9wia17j7jp60hzyrk";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
