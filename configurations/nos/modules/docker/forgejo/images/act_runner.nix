pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:e6190fc19ad01f1a7e8cf8f1b60d47a21ceffa9dbaa3077e4a951c058b79ca53";
  hash = "sha256-Z3VAItSp9r4M2lA9CleYkT3afb0Dclnh5DmPyFE9YfE=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
