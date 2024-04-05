pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:f793df4ed40227cd66dfbba730a448c23f14d81bf9d17857a352011bf6c06907";
  sha256 = "1c05n1w9f06mcwgpmswclbba898bwsqhx1mdlmi97nphphp9bmq5";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
