pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:bc45d248c4e1d1709321de61566eb2b64d4f0e32765239d66573666be7f13349";
  hash = "sha256-BgQsWca5dtewqzcupcP67I6zBQWCNRIveKU5GM59Njk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
