pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:8541484afbc9c8a5a8a99b379568ebbc957f658583ec9448fc43104229c03cf8";
  hash = "sha256-MKObz5S/AvvahZXQvJJ3XXs2d2qHFpXoGyT4YDGZ+2Q=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
