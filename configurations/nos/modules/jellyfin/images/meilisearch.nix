pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:82767d2afc4fb6c3e4ebadb134ca6ef5687c894ae9e152928619393b1f331681";
  hash = "sha256-3LFk+6C/vqiimsnETgSprhNX0PeF25SdlmqXv1QsOHs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
