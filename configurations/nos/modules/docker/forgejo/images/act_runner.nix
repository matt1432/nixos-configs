pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:a587df58615ddadf61caabdd904c6493ef0419efbda3e523edac96bb52689773";
  hash = "sha256-VLbxiFdaZX0dWIyWurX6exli9y7JKSU/1BWT/9Dyopw=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
