pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "data.forgejo.org/forgejo/runner";
  imageDigest = "sha256:d85b420efea6f0137fe03f285b05df73e0c34cfbfc2c6a96d22cc52f38106d8c";
  hash = "sha256-JEoiapo2UUrhLpR7nRZzc9t8lbJqabJpvMNAK8/GNhU=";
  finalImageName = imageName;
  finalImageTag = "12";
}
