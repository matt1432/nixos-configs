pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:7f462f66f0e360ad2dd023a35634711439f115d4a3c69d4ff68c8425d9e174d9";
  hash = "sha256-Loa0v+76Cmjkh1zGSUnd56l/MgMhHCLYoTQQ0iQYqAM=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
