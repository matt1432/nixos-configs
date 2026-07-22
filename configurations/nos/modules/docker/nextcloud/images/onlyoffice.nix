pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:3ab6ebc7c605e5a32b7ae3ff19daed4925090245acc8100ce2230bd766c88212";
  hash = "sha256-dY+uGGGi9j1HkTqNG8A8y4UmrNjRIXhJRwVUFHUKlNk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
