pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:b785240f713d93f4a2d2a82926eacd0ac1deeae360d8ddfbd456102850285efb";
  sha256 = "0z2vd663zyyfcz0rnl2ksivxmh63nhh4g42qx2idqb6j27s426bq";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
