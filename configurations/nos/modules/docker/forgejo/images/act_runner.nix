pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:b918e08b14472ed8d0727e6a14948f252b99f4b5d2c0a68e283f816db4f28aa0";
  hash = "sha256-zkb7Yus1p9yv7HO1+byDepPzhRHjLlrjKLvqM5ZTXIs=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
