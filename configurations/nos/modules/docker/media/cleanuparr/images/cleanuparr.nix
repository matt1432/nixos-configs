pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/cleanuparr/cleanuparr";
  imageDigest = "sha256:e054e703c4ded95c80743d9a9ff7ffe6ba6531e193327c5b1d63187178354113";
  hash = "sha256-eNuoC7VfF+TyFXm6fE150qBnArqaEEU++dEf1EiXRsM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
