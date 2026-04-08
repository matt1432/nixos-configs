pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:2195de2bc27ad5bf89a4d4b3f87e00efa5ec74195fcaf0754348b0240ad4caa2";
  hash = "sha256-LXUzQn6PzB9hAgGqiLykXUTgRwsCt9ms90X0jFuBjqY=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
