pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:0ca72dae460b7fd2dbd0ca146fdddfd26b1c1af783f37659c2f1bdd546fdf1e4";
  hash = "sha256-vLeRHBRusmzxaM4mCtpTag6brB2+CONBL1nlcpq58eY=";
  finalImageName = imageName;
  finalImageTag = "release";
}
