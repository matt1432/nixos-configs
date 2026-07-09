pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:bdc7d7e7939911c40d88d6bcd01f9c72c81f7293135916d48bce241569f721bd";
  hash = "sha256-JdqCjfznKgkeExoyX5g25aRCdE4C09RYVH+nmmIXUbs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
