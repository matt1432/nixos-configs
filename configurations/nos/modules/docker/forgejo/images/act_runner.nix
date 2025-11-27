pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:b949709119d4080b19c1907ca67d6a551b22ac722648d6c4120bd9e97c15849a";
  hash = "sha256-a97TTZx7U0iaWkHGw9NhkQ7TE694ny1lOjirndXXNaY=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
