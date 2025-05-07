pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:0ed2fefe4fcea37c5f7b37afb08044e31b471001b12c52712ffbf5f9db220e97";
  hash = "sha256-UClpiX30n4kEUI0ETFD5nRJYG5+fjUZ5ajN/4nZuOnM=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
