pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "netdaemon/netdaemon4";
  imageDigest = "sha256:006164da18303a05e57782088b2fc207d52f47d1429a54d0b0fe2341e1570510";
  sha256 = "1px913mh8fqhxg7s5np607gn96qrijd0r8a9mj72khnvqjnmbqgg";
  finalImageName = imageName;
  finalImageTag = "24.43.0";
}
