pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:9a5cff46f51224006fd5e605484bba42faea00a18065c4ef4ee2d18ad47307bc";
  hash = "sha256-ejleIdAgxWgLLGl+6sZ7YQ0gcGn61w1yn9P8rPezQ20=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
