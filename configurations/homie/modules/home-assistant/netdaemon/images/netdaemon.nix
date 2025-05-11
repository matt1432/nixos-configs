pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "netdaemon/netdaemon5";
  imageDigest = "sha256:28335e5f72a9a0c9801e9e46c90157a2a143771b59124bf9d2cc3789e4908986";
  hash = "sha256-OrSdEWD8fHDkme2TPPmqd/6FyWOMmf4flRNEghJfZnc=";
  finalImageName = imageName;
  finalImageTag = "25.18.1";
}
