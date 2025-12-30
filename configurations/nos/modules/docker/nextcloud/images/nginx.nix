pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:ad85427e8c7147e2bfb485f7829e46316495695d7936a6d4459cfcfd351535cc";
  hash = "sha256-0KqSDVmK8SUURIDtT4zSeMCx4ErAAxg10v5No6WWH4M=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
