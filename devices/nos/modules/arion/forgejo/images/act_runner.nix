pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:b01252cedc304c2f2ca6c4244c818016eeb82c7b1e9b4d9385cf9a9dd1fb8a99";
  sha256 = "096ykmx3qrzmacbq6kggxk9082wb6hhmkzanqipsl7qwb1j312d3";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
