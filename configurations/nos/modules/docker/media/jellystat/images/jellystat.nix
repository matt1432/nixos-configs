pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "cyfershepard/jellystat";
  imageDigest = "sha256:c8c451704ba7985340142cd047e2364cabaf41b613669b6c5340688ed217f82a";
  hash = "sha256-vlQoKtUtaaINTzpI0rfKkQPJRKTRsRzMWngaO3wZSUA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
