pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "cyfershepard/jellystat";
  imageDigest = "sha256:683358900cff8d299fa93add731b2976d7c9bc49f9593f40f5351498fd488767";
  hash = "sha256-7IQbvKZuTgaOuFnoKAF9AD24C9ZMhn09Hsycrkt+vXY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
