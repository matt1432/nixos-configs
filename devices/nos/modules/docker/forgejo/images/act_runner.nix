pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:5686ce9464839df7333098a61a802d16645d92fa4175b02684a536656d17a28f";
  sha256 = "1wbx08ps26i4cpg3gz4sg919zy8dhabsq2szj18vf66xla57q8xw";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
