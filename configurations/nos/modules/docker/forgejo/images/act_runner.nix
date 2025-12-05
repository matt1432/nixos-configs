pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:1942a81510ac2dc956cb31547188e0684b87e71b26e8bc397f189708d7a14556";
  hash = "sha256-iPyn1GxzWd+zGNCKZrIH+Z/Lb5G/DJAQe1dXtIe84Ek=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
