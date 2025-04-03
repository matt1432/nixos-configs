pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:1abb9999d9e44103f1f4e19a345fd33c2675253bb839053ffc698bfb85604c22";
  hash = "sha256-mqTTH/gCOKIbwNPPLeVEXU3Ad3JpjS9sWVej5a3xf6M=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
