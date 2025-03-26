pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:b3682aa0873960e8b8d5a1ec35417063b1a11a2a7b12dbc89f959346b57e38ea";
  hash = "sha256-mUQavetqfVWUn3XHlhZdwCpzljLKzjpNJ4e0oZzhkpA=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
