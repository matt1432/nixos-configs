pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:7c4e1db440be7b2ca685b49d0d7864cdd78e92431f531bf7893659def8200fc5";
  hash = "sha256-ByCpdT3G0T+Yd/JN/9eeyZyo4Ca2YlKX2a5oHjV40wQ=";
  finalImageName = imageName;
  finalImageTag = "16";
}
