pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:46622dffb0b61ff4330003a080d5844043be2cd395657b57190337a5c03b49a8";
  hash = "sha256-IePZKl0n7IfDwh3+aUVuBv6v0bCmN+91akxgfRwhel8=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
