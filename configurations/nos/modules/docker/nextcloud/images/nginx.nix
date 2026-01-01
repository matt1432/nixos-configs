pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:ca871a86d45a3ec6864dc45f014b11fe626145569ef0e74deaffc95a3b15b430";
  hash = "sha256-0KqSDVmK8SUURIDtT4zSeMCx4ErAAxg10v5No6WWH4M=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
