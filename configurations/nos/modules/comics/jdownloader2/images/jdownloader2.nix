pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker.io/jlesage/jdownloader-2";
  imageDigest = "sha256:a597e25a5be386cac5519f2fc705eadb786727f9f0f2c7440fb5585efa41973f";
  hash = "sha256-kZRMR1cv5jad+BQkxgvuKIcVod42neszkU9/RPh7BNY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
