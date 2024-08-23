pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:051d40d9f2171f6d870a2ac5bd025e6986df276b81d598441afdd953aad5f815";
  sha256 = "17cy33mxhyql6wxv8clnn6vcy2iylw7flddfmsv1n7l1hcp0nsck";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
