pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:6e59daffeaf0be4c2588853a67cb23335a34a8f0ae393983f61f658bc62a4890";
  hash = "sha256-39Fkj3QRUKnnvGf0mSJq54QQMg7LQYVuoFNSeYwJE0Y=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
