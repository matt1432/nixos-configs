pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:2a987557c09d5cede2d97d2049084518d8500fe984cd06bad09559e67704473b";
  hash = "sha256-BW8DvQ6JtiMX7ZE0ihSvpsT3nmfENkNC+yHzlEWOBx8=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
