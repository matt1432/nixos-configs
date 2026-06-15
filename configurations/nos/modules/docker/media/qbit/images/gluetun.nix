pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:0e999c910d8077458ffbd869acfd9faa2a49decbca02afec6370277854587b3e";
  hash = "sha256-ljShxkEwRowaqLXvMDFNDHCPoAJ3unQb7hkKLk7q/WI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
