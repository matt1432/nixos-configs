pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:cbafe0945d0fe5a3c55ca64d43a85c5db270458f4c645ee65797b527f6f57a64";
  hash = "sha256-uxU0Vghb60nev+3/6tvEIH9lzj8Sgd78l/3HArcbk7M=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
