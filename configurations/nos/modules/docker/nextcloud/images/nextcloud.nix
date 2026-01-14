pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:c21c27e6d2714d424ad0649f83d635762bf1f58e81cc399966caeb7166db349f";
  hash = "sha256-Xv50NpvskVoi835zTQpuOUtG5BeGIgoiycjq4BGCCvc=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
