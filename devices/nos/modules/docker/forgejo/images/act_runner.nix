pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:ea8e9a0304fba7648b62fe19c39c38dd08e8c71b8d2a0cac65f834ccf6215daf";
  sha256 = "1x2vnnz38jivrk4wmqymxlhmaz0vasq81r6p9zlfr7pwj8hysj4m";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
