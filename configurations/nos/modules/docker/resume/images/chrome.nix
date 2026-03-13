pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/browserless/chromium";
  imageDigest = "sha256:6ce6361efecb2c60632eb635ae3e987df2c18b498e0d7ca1deac7551a58f666b";
  hash = "sha256-v1wdPlFy682HnyOvkAvyQ0VtHy2He3UH2Qmygv+nI2o=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
