pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:09369da6b10306312cd908661320086bf87fbae1b6b0c49a1f50ba531fef2eab";
  hash = "sha256-PH3jMib/DmusC9KTtyYTSdUxEj8AvWx86/SWBdOwOvA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
