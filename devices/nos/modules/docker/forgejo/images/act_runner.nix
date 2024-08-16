pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:1ddf1cb7a19b7dd314e1fd5762e7e69e084d1818778f535969fd1727484ae41c";
  sha256 = "09dkfg0hwcrf2whzmspw9fn2z84hy75r2srjk1lwa4xm4dgl27q6";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
