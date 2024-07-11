pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:4e886252cad4a7796289a737afb4b47e9b547b7e2d2b9e35fd3153c8f97eefca";
  sha256 = "10xan2lwgi77qgmq964j290xykn4pk75r397fqj5kkkbxkqbndgh";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}
