pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker";
  imageDigest = "sha256:9e79b879b177fbd72c34376a3dd3d91747da5db49e1f560f76aea59561471977";
  hash = "sha256-0+mFt5jH7iot3sqK1YMFEmutqik8mBJnLgwAFp9qyyk=";
  finalImageName = imageName;
  finalImageTag = "dind";
}
