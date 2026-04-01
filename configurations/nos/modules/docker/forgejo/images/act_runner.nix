pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:4d4bb214f2b1505e592976e640f761aebf4c5e1c7e282633496692e2aa381437";
  hash = "sha256-C8GxuKbW6cxfDVScNd/OGZvoewDXvsS6PE/xrtTuJq0=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
