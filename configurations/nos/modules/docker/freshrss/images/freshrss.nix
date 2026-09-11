pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "freshrss/freshrss";
  imageDigest = "sha256:258b8edfc8a76a61f60d2d6a14d8f8d12495d78abf38646a2137612dfa264a21";
  hash = "sha256-ab9G4gHxYfCsvsYQzI8V2a6T2kfR4nl0AAUL2vmRvtg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
