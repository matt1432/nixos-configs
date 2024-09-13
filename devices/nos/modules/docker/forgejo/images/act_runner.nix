pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:acc510a4754aa871dcaac69396055fea3117b5378a36efd9fbf3b3db542fa81a";
  sha256 = "12a9gw7nl5g4ji8jcg9w55a5zx7q9ny80bfk5qhl05yj7h6514ni";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
