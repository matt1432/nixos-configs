pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:1cb04d85979d671a20c045d23c99bb64df9d4c4d42c236778db0583e146b0b9a";
  hash = "sha256-65bcnbXuSKPXL7krm6S+JB2nWZTzi7i2PhhwEdxy9IY=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
