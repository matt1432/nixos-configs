pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:3aa5f08888f2bd583f8caa0da287e325db375bf607db3353b886272d12d1e12b";
  hash = "sha256-ejleIdAgxWgLLGl+6sZ7YQ0gcGn61w1yn9P8rPezQ20=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
