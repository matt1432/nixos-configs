pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:048d2fd69f4af63a69cb3ae7d8e76777a0cc128acac89a3299c45e80a6670a98";
  hash = "sha256-BRCRedRPJcmtBafd/b067JMPEFwRCgd+NjdV4qVXhiQ=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
