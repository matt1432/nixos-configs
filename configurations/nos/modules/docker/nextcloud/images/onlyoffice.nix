pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:ca17889f10b11141cc6441836aebdd2835cf3e1b49681b2fd6e155c94b7850b3";
  hash = "sha256-bpG0dt/3bW/dC0uev279jZZXMuaZOnT7+sSjMHGQkgg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
