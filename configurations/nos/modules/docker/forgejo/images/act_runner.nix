pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:af12d7fcf43c5df829950e018d86c74fa958f3b0bce9ed16279105b2f510a4dc";
  hash = "sha256-kl8l063JNlVOzp6KLpmcNg73rdqNEhW+xJstbPMECfE=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
