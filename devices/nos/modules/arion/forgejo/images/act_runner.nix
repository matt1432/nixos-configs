pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:ee458881e40c346b5324add5ee74a532be4edf2b9ac7b537e1bd8e649b8c811c";
  sha256 = "1x9qdn1cxzps700dhvaa2w5fz54znghma15jsrws7ldwiq2nl21n";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
