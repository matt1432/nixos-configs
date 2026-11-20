pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:84f7876d21d154885f99554d7ae325d8c2213f9169726ea7ab60642f2573a787";
  hash = "sha256-p0WY64c4B45lX98Z0zmG83J25D44SEVMyiqYanbP2bc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
