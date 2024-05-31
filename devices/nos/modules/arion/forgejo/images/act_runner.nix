pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:c85f5b0c3ee49b1307f266e914e7efe4b8a20cc3ff1182bb238cb223138a45a8";
  sha256 = "012sykcw14n0cfv42f7z47z41ifwdl73if1x7mrmyf9jbkhrgb29";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
