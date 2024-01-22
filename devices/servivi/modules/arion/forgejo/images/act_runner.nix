pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:10965cf2fcd3cc146f2bd54e0234d55a499f1dedc3a1f2edd7fb5736b4921904";
  sha256 = "0pi09zz7agm33jbd41zi94lqfxmq7q64z2lfjlmdp9aq1q254zxw";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
