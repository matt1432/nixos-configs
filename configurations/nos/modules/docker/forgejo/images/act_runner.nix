pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:f618567b7e78582feb4616567761c0812810206a89c53756e068993f809fc171";
  hash = "sha256-LJ0YVoX+CZ6OkWMGRIExOjthd4k2zTso0P3uQ4d8P/A=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
