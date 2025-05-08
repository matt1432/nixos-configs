pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "netdaemon/netdaemon5";
  imageDigest = "sha256:52b65e705d49caf56ee54c44b9fed1bee7f7dcfd7e478011ebf914eecfdcaf63";
  hash = "sha256-nriOzNrbmzI24F/qQGXoGh2U9AC76h2FosY38eNufpM=";
  finalImageName = imageName;
  finalImageTag = "25.18.0";
}
