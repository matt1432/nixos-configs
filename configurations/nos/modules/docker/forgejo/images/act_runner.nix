pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:a1fedede2772e6d9fb5fefc844f883a505d36374ccd4d80188daeb4e7a92bb5c";
  hash = "sha256-bAhM0tzq5A7SLKNsbRv0ZCZnj3O8RrStGl55RrE/yvc=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
